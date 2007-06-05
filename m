Return-Path: <linux-kernel-owner+w=401wt.eu-S1764899AbXFESp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764899AbXFESp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 14:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758717AbXFESpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 14:45:14 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2075 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbXFESpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 14:45:13 -0400
Message-ID: <4665AF40.5020800@shadowen.org>
Date: Tue, 05 Jun 2007 19:45:20 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: jschopp <jschopp@austin.ibm.com>
CC: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
References: <0a25fd03117c678f17006c5fcefaaed0@pinky> <466434A1.4040905@austin.ibm.com> <4664430C.1070909@shadowen.org> <46644A48.4090300@austin.ibm.com>
In-Reply-To: <46644A48.4090300@austin.ibm.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jschopp wrote:
>> The original suggestion was to count them and only complain if there
>> were "lots".  I had thought though that the general consensus was that
>> #ifdef in C files was pretty much frowned upon.  I must admit to working
>> to the "you must be able to justify all winges in the output" rather
>> than expecting the result to be empty necessarily.
> 
> I really think we should work towards, "if you see an error the odds are
> overwhelming that we aren't wasting your time and you should fix this."
> rather than, "every time you send a patch you will get a couple false
> positives that you will have to think about and justify to yourself,
> slowing down your sending the patch out and making more work for you". 
> I'm not saying we have to have 100% accuracy, but I want it well in the
> 90s.

Yeah I tend to agree and most of my work to date has been squashing
false positives.

> Now back to the ifdef's.  I don't think we can really even say a lot or
> a little is broken (short patch can do 1 ifdef that is stupid, long
> patch could do several that are good).  I think we'll either have to let
> that one go or put it under a non-default flag.    We do still have
> humans reviewing code who can make judgement calls like if you #ifdefs
> are good or not.
> 
> What we can check for is #if 0 code.  I hate that one.

For now I've disabled this one.  Put it in the freezer with the
StudlyCaps one.

I like the idea of checking for #if 0 as that is very likely bogus in a
patch meant for inclusion.

>> We've not talked about how the tool might grow.  My thought was that
>> soon we would enable the robot replies on linux-mm (say) and use the
>> feedback from that to tune what we do and do not report.  I have been
>> pushing all of the contributions to -mm for sometime through it and
>> cirtainly the #ifdef one once of the more common ones (other than white
>> space dammage and >80 character lines).
> 
> If you have reasonably good SPAM filters on your list and make the robot
> so it is very good about only picking up mail that really are patches
> then this could be a very good idea. Just be careful.  I could send out
> a bunch of mail with fake headers saying it was from say Andy Whitcroft,
> then the robot replies and you got a bunch of junk mail.

All very good points.  It does only reply to emails which are clearly
unidiff patches and silently drops all else.  But the potential for spam
is worrysome ... will think on this some and see if we can come up with
a safety net.

> User feedback is really useful, both for us and for the user.  Based on
> user feedback from the very small number of users I had I tweaked a lot
> of regular expressions, added some new checks, and removed some I could
> never get right.

I am getting a fair bit of feedback, most of it copied to Joel and Randy
so at least that bit is working.

-apw
