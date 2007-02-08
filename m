Return-Path: <linux-kernel-owner+w=401wt.eu-S1423334AbXBHVMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423334AbXBHVMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 16:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423363AbXBHVMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 16:12:19 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:46296 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423334AbXBHVMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 16:12:18 -0500
Date: Thu, 8 Feb 2007 22:10:23 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0702082202180.24888@yvahk01.tjqt.qr>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 8 2007 11:53, Linus Torvalds wrote:
>On Thu, 8 Feb 2007, Jan Engelhardt wrote:
>> 
>Exactly because "char *" doesn't have a defined sign,
>The user has clearly stated "I don't care about the sign". If a compiler 
>complains about us passing "unsigned char *" (or, if "char" is naturally 
>unsigned on that platform, "signed char *") to strcmp then that compiler 
>IS BROKEN. Because "strcmp()" takes "char *", which simply DOES NOT HAVE a 
>uniquely defined sign. 

Thank you for this insight, I don't usually read standards, only RFCs :)
Uh, does that also apply to the longer types, int, long etc.? I hope not.

>only a TOTALLY INCOMPETENT compiler will warn about its signedness.
>That's why we can't have -Wpointer-sign on by default. The gcc warning is 
>simply *crap*.
>[...]
>It really is that simple. gcc is broken. The C language isn't, it's purely 
>a broken compiler issue.

Maybe you could send in a patch to gcc that fixes the issue?


Jan
-- 
