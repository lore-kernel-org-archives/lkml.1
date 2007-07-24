Return-Path: <linux-kernel-owner+w=401wt.eu-S932608AbXGXUxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbXGXUxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbXGXUxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:53:39 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42649 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbXGXUxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:53:38 -0400
Message-ID: <46A666CE.4010905@austin.ibm.com>
Date: Tue, 24 Jul 2007 15:53:34 -0500
From: jschopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
References: <740c90243aaa6f6d4640d71230c4fa27@pinky> <46A534EA.6030008@intel.com> <46A5C12B.3080904@shadowen.org> <20070724021526.3d92286b.akpm@linux-foundation.org> <20070724172217.GA10725@linux-sh.org> <46A648C5.5050902@austin.ibm.com> <20070724195908.GF6019@stusta.de>
In-Reply-To: <20070724195908.GF6019@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> So, no we shouldn't separate out CodingStyle because
>>
>> Better CodingStyle == less bugs
>>
>> and
>>
>> Better CodingStyle == more throughput for maintainers
> 
> To some extent yes.
> 
> But extreme codingstyling won't gain you anything.
> 
> Except for long and fruitless discussions.
> 
> If a tool says anything would be wrong with the line of C code
> 	int i, j;
> for two loop variables, then the tool is wrong because that's an idiom 
> every C programmer knows and understands.

I'm fine with whatever we decide is acceptable coding style, and changing the tool to 
match is work I'm willing to do.  If we decide declaring multiple variables on one line is 
bad, except if they are named i,j, or k then that's fine.  If we decide declaring 22 
variables per line is OK but 23 per line is bad then I'm fine with that.

If a check doesn't complain about bad code hundreds of times for every 1 time it complains 
about good code we will fix the check or remove the check entirely.

Andy already removed the multiple variable declaration per line check for the next version 
for that reason, it complained about arguably good code too often (to be fair many would 
say int i, j; is bad code).  Someday when we get the check fixed to handle sane multiple 
variable declarations better I'd like to add the check back in so the insane multiple 
variable declarations gets warned.


