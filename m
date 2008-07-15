Return-Path: <linux-kernel-owner+w=401wt.eu-S1761346AbYGOOWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346AbYGOOWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 10:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760940AbYGOOVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 10:21:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35310 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758419AbYGOOVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:21:46 -0400
Subject: Re: [PATCH] x86: traps and do_traps under one hood
From: David Woodhouse <dwmw2@infradead.org>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>, andi@firstfloor.org
In-Reply-To: <1216119158.21749.5.camel@jaswinder.satnam>
References: <1216119158.21749.5.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 07:21:43 -0700
Message-Id: <1216131703.27455.245.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 16:22 +0530, Jaswinder Singh wrote:
> Declaring x86 traps under one hood.
> Declaring x86 do_traps before defining them.

> arch/x86/kernel/traps_32.c                |   20 ---------
> arch/x86/kernel/traps_64.c                |   21 ----------
> include/asm-x86/mach-default/mach_traps.h |   62 +++++++++++++++++++++++++++++

You put these back in mach-default/mach_traps.h but does that cover all
possibilities? What about other machine types?

Looking at the ifdefs you introduced in that header, it seems there's
more scope for unification here (although it makes sense for that to
come later).

-- 
dwmw2

