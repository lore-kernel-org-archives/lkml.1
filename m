Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbYLKFIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbYLKFIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 00:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbYLKFI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 00:08:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:50136 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbYLKFI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 00:08:26 -0500
Date: Wed, 10 Dec 2008 21:09:55 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc8
Message-ID: <20081210210955.36fa2965@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 17:04:39 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> Nothing overly exciting here. Lots of small things, mostly in drivers 
> (with some defconfig updates for m68k and mips making the diffs
> bigger). 
> 
> There's some uncomfortably big changes to the intel DRI code, but
> most of that is all about fixes to the new i916 "GEM" code that is
> only used by development X servers, and is a new feature, so it
> shouldn't be able to cause regressions.
> 
> Perhaps more interesting is simply the release scheduling issue. I'm 
> getting slowly ready to do a real 2.6.28, but I don't think anybody
> really wants the merge window to be around the holidays. So the
> question is really whether to 
> 
>  (a) just make the -rc's go on a few more weeks, and do 2.6.28 after
> xmas
> 
>      I like this, because alledgely people are debugging things, and
> we'd get a more stable 2.6.28.
> 
> or
> 
>  (b) release in a week or two, but just allow for possibly extending
> the merge window due to people being drunk on eggnog..
> 
>      I like this because let's face it, we get more and better bug 
>      information after releases, and everything _should_ be ready for 
>      merging *before* the merge window anyway.
> 

if you go for option (b) I would suggest doing an -rc in the middle, or
at least some snapshot release, to act as anchor point for the second
wave... maybe even a day or two of quiet around that to give people
time to regroup.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
