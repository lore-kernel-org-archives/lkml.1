Return-Path: <linux-kernel-owner+w=401wt.eu-S1759945AbXK1Vo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbXK1Vo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 16:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbXK1Vou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 16:44:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:54601 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672AbXK1Vot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 16:44:49 -0500
Date: Wed, 28 Nov 2007 22:45:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [patch] Fix hpet wrong values
Message-ID: <20071128214521.GA6918@elf.ucw.cz>
References: <20071127122308.GA2640@elf.ucw.cz> <20071128103851.GA19701@elte.hu> <20071128104040.GA20113@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128104040.GA20113@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> >  ---------------->
> >  e09e9089131ca0227a716aee143f49d084977e32 is first bad commit
> >  commit e09e9089131ca0227a716aee143f49d084977e32
> >  Author: Pavel Machek <pavel@ucw.cz>
> >  Date:   Wed Nov 28 03:06:03 2007 +0100
> > 
> >       x86: fix wrong hpet values
> >  <----------------
> 
> it's the hpet_enable() returning non-0 that is causing the crash. The 
> current patch that is in x86.git is below.

Sorry about that. Andrew already dropped the patch, you probably want
to drop it from x86 tree, too...
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
