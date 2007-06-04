Return-Path: <linux-kernel-owner+w=401wt.eu-S1759038AbXFDQv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbXFDQv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757096AbXFDQvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:51:21 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4617 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945AbXFDQvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:51:20 -0400
Message-ID: <4664430C.1070909@shadowen.org>
Date: Mon, 04 Jun 2007 17:51:24 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: jschopp <jschopp@austin.ibm.com>
CC: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
References: <0a25fd03117c678f17006c5fcefaaed0@pinky> <466434A1.4040905@austin.ibm.com>
In-Reply-To: <466434A1.4040905@austin.ibm.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jschopp wrote:
>> This version brings a host of changes to cure false positives and
>> bugs detected on patches submitted to lkml and -mm.  It also brings
>> a number of new tests in response to reviews, of particular note:
>>
>>   - catch use of volatile
>>   - allow deprecated functions to be listed in
>> feature-removal-schedule.txt
>>   - warn about #ifdef's in c files
> 
> 
> I think the design philosophy of the style checker should be to err on
> the side of being quiet.  It shouldn't report things that aren't
> problems.  There are plenty of valid uses of #ifdefs in c files. 
> #ifdefs may be abused often.  If we start bothering every author that
> uses #ifdefs with an annoying note it detracts from the usefulness of
> our tool.
> 
> If we really want to complain about #ifdefs we should add a flag to the
> script so it isn't a default.  -potential or something.  We could put
> all the "this often is an error" type warnings under it.

The original suggestion was to count them and only complain if there
were "lots".  I had thought though that the general consensus was that
#ifdef in C files was pretty much frowned upon.  I must admit to working
to the "you must be able to justify all winges in the output" rather
than expecting the result to be empty necessarily.

I am ambivalent on what gets reported as long as its generally useful.
I as you say don't want to produce so much noise that it hides the
useful output.

We've not talked about how the tool might grow.  My thought was that
soon we would enable the robot replies on linux-mm (say) and use the
feedback from that to tune what we do and do not report.  I have been
pushing all of the contributions to -mm for sometime through it and
cirtainly the #ifdef one once of the more common ones (other than white
space dammage and >80 character lines).

-apw
