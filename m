Return-Path: <linux-kernel-owner+w=401wt.eu-S1758406AbXGXSac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406AbXGXSac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbXGXSaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:30:19 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4312 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbXGXSaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:30:17 -0400
Message-ID: <46A64534.1040207@shadowen.org>
Date: Tue, 24 Jul 2007 19:30:12 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: lkml <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
References: <740c90243aaa6f6d4640d71230c4fa27@pinky>	<46A534EA.6030008@intel.com>	<46A5C12B.3080904@shadowen.org>	<20070724021526.3d92286b.akpm@linux-foundation.org>	<46A5E034.2030205@shadowen.org>	<Pine.LNX.4.64.0707241849340.18990@fbirervta.pbzchgretzou.qr>	<20070724102035.6447565c.randy.dunlap@oracle.com> <20070724110339.9fd0853e.randy.dunlap@oracle.com>
In-Reply-To: <20070724110339.9fd0853e.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Tue, 24 Jul 2007 10:20:35 -0700 Randy Dunlap wrote:
> 
>> On Tue, 24 Jul 2007 18:51:39 +0200 (CEST) Jan Engelhardt wrote:
>>
>>> On Jul 24 2007 12:19, Andy Whitcroft wrote:
>>>>>>> if (err) {
>>>>>>>     do_something();
>>>>>>>     return -ERR;
>>>>>>> } else {
>>>>>>>     do_somthing_else();
>>>>>>> }
>>>>>> 	if (err) {
>>>>>> 		do_something();
>>>>>> 		return -ERR;
>>>>>> 	} else
>>>>>> 		do_something_else();
>>>>> The kool kids on linux-usb-devel largely ended up deciding that the second
>>>>> version looks dorky.
>>>> Ok, now if either the preceeding block or following block has {}'s then
>>>> we don't report this block for being one line long.  We will miss some
>>>> this way, but hey.
>>> As per Ingo Molnar [ http://lkml.org/lkml/2006/9/5/68 ],
>>> all blocks in an if-else 'tree' should be {} if there is at least one
>>> with more than two statements. (And I do not disagree.)
>> You are actually referring to this commit:
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e659ba4a0d2d471c0d73590f78e1a1b5a1eede48
>>
>> which did not appear on lkml for review... :(
> 
> Oops, I stand corrected (my previous search was based on the patch filename):
> 
> http://lkml.org/lkml/2007/5/4/50
> or
> http://marc.info/?l=linux-kernel&m=117826369817272&w=2

Well the summary of the discussion there was one vote for the new
standard, two votes against and a "lets leave it open".  So it seems odd
it was ever added to the CodingStyle.

The "leave it undefined" makes the current behaviour of checkpatch
wrong.  So its good I've loosened it for the next release.

-apw
