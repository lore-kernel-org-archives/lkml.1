Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab0CBTTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 14:19:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56957 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab0CBTTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 14:19:43 -0500
Message-ID: <4B8D6275.30100@zytor.com>
Date: Tue, 02 Mar 2010 11:09:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@linux.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sachin Sant <sachinp@in.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Alok Kataria <akataria@vmware.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       =?ISO-8859-1?Q?Pasi_K=E4rkk=E4i?= =?ISO-8859-1?Q?nen?= 
	<pasik@iki.fi>
Subject: Re: [GIT PULL] x86/mm fixes
References: <201003020010.o220Ax3Z025848@hera.kernel.org> <alpine.LFD.2.00.1003021038410.3616@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003021038410.3616@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2010 10:39 AM, Linus Torvalds wrote:
> 
> 
> On Tue, 2 Mar 2010, H. Peter Anvin wrote:
>> +		pfn = (res.start + PAGE_SIZE - 1) >> PAGE_SHIFT;
>> +		end_pfn = (res.end + 1) >> PAGE_SHIFT;
>> +		if (end_pfn > pfn)
>> +		    ret = (*func)(pfn, end_pfn - pfn, arg);
>>  		if (ret)
>>  			break;
>>  		res.start = res.end + 1;
> 
> What kind of messed-up indentation is that? We don't use 4-char indents.
> 
> 		Linus

Sorry, you're right.  I have to admit I didn't even see that aspect of
the patch.

I'll add a reformatting patch and update the branch, if you want.

	-hpa

