Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbXCUD7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbXCUD7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 23:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbXCUD7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 23:59:22 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:54234 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbXCUD7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 23:59:21 -0400
Message-ID: <4600AD92.7070205@in.ibm.com>
Date: Wed, 21 Mar 2007 09:29:14 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, rdunlap@xenotime.net,
       jlan@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: taskstats accounting info
References: <Pine.LNX.4.58.0703140503250.28169@shark.he.net> <45F7E818.7010608@in.ibm.com> <20070315110655.5a815f2e.akpm@linux-foundation.org> <20070319083512.908fc695.randy.dunlap@oracle.com>
In-Reply-To: <20070319083512.908fc695.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Thu, 15 Mar 2007 11:06:55 -0800 Andrew Morton wrote:
> 
>>> It's the most portable example, since it does not depend on libnl.
>> err, what is libnl?
> 
> lib-netlink (as already answered, but I wrote this last week)
> 

I was referring to the library at http://people.suug.ch/~tgr/libnl/

>> If there exists some real userspace infrastructure which utilises
>> taskstats, can we please get a referece to it into the kernel
>> Documentation?  Perhaps in the TASKSTATS Kconfig entry, thanks.
> 
> 
> Balbir, I was working with getdelays.c when I initially wrote
> these questions.  Here is a small patch for it.  Hopefully you can
> use it when you find the updated version of it.
> 
> ~Randy
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> 1.  add usage() function
> 
> 2.  add unknown character in %c format (was only in %d, not useful):
> 
> ./getdelays: invalid option -- h
> Unknown option '?' (63)
> 
> instead of:
> 
> ./getdelays: invalid option -- h
> Unknown option 63
> 
> (or just remove that message)
> 
> 3.  -v does not use an optarg, so remove ':' in getopt string after 'v';
> 

Thanks, these look good. I'll add them to my local copy.



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
