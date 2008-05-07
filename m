Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbYEGVAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbYEGVAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756327AbYEGU7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:59:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:54820 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764795AbYEGU7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:59:01 -0400
Date: Wed, 7 May 2008 22:59:43 +0200
From: Pavel Machek <pavel@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Adrian Bunk <bunk@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: 2.6.26, PAT and AMD family 6
Message-ID: <20080507205942.GB18516@elf.ucw.cz>
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > And this patch (by the author of the code himself) is the first time 
> > where it breaks.
> 
> Very interesting analysis. What broke ? This CPU was never in the set
> of supported ones at all.
> 
> Anyway, you are welcome to review x86 code - it can definitely use
> more eyeballs, but please try to inform yourself about the topic or
> ask polite questions before yelling at people who contribute in a
> very valuable way.

Can we get rid of that copy&paste programming? They should have been
fixed _before_ merging the patch, but better late than never...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
