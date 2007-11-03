Return-Path: <linux-kernel-owner+w=401wt.eu-S1762724AbXKCXxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762724AbXKCXxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 19:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758977AbXKCXxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 19:53:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59191 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006AbXKCXxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 19:53:13 -0400
Date: Sat, 3 Nov 2007 16:52:47 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] replace "make ARCH=i386/x86_64 with make ARCH=x86"
Message-ID: <20071103165247.3663f518@laptopd505.fenrus.org>
In-Reply-To: <20071103234826.GA26654@uranus.ravnborg.org>
References: <20071103234826.GA26654@uranus.ravnborg.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Nov 2007 00:48:26 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:

> This patchset unify the i386 and x86_64 Kconfig
> files for x86.
> In addition it replaces the use of ARCH=i386 and
> ARCH=x86_64 with the more intuitive ARCH=x86.
> 
> The primary purpose of this patch serie is to 
> enable make ARCH=x86 and let the config decide
> if we are building for 32 or 64 bit.
> 
> But we will break quite a high number of
> scripts with this change.
> What is the desired behaviour when specifying:
> make ARCH=i386
> and
> make ARCH=x86_64

I would say.. just print a very very nasty warning, wait 20 seconds,
and then pretend it was passed as x86
and then remove in the next release (assuming the code isn't too ugly)

other than that.. just break it now in 2.6.24; people at least remember
.24 as the release that unified, so they expect changes there... they
won't expect them for .25 or later
