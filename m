Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbXJBDmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbXJBDmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 23:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbXJBDlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 23:41:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43253 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920AbXJBDlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 23:41:51 -0400
Date: Mon, 1 Oct 2007 20:41:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Message-ID: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I said I was hoping that -rc8 was the last -rc, and I hate doing this, but 
we've had more changes since -rc8 than we had in -rc8. And while most of 
them are pretty trivial, I really couldn't face doing a 2.6.23 release and 
take the risk of some really stupid brown-paper-bag thing.

So there's a final -rc out there, and right now my plan is to make this 
series really short, and release 2.6.23 in a few days. So please do give 
it a last good testing, and holler about any issues you find!

This is also a good time to warn about the fact that we're doing the x86 
merge very soon (as in the next day or two) after 2.6.23 is out, so if you 
have pending patches for the next series that touch arch/i386 or x86-64, 
you should get in touch with Thomas Gleixner and Ingo Molnar, who are the 
keepers of the merge scripts, and will help you prepare..

Doing it as early as possible in the 2.6.24-rc4 series (basically I'll do 
it first thing) will mean that we'll have the maximum amount of time to 
sort out any issues, and the thing is, Thomas and Ingo already have a tree 
ready to go, so people can check their work against that, and don't need 
to think that they have to do any fixups after it his *my* tree. It would 
be much better if everybody was just ready for it, and not taken by 
surprise.

In other words, people who know they may be affected and would want to 
prepare can look at (for example)

	git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-x86.git x86

and generally get ready for the switch-over. 

			Linus
