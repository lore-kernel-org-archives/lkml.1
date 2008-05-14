Return-Path: <linux-kernel-owner+w=401wt.eu-S1751373AbYENUPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbYENUPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 16:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbYENUOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 16:14:35 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:47003 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbYENUOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 16:14:33 -0400
Date: Wed, 14 May 2008 22:14:30 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@suse.de>
cc: Cyrill Gorcunov <gorcunov@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: main.c:(.init.text+0x730): undefined reference to `strlen'
In-Reply-To: <je1w44ucrc.fsf@sykes.suse.de>
Message-ID: <Pine.LNX.4.64.0805142214000.11631@anakin>
References: <Pine.LNX.4.64.0805140958400.5778@anakin> <jeprrpth5m.fsf@sykes.suse.de>
 <20080514141056.GB19909@cs181133002.pp.htv.fi> <jeabitt0xj.fsf@sykes.suse.de>
 <20080514144031.GA6902@cvg> <je63thszo6.fsf@sykes.suse.de> <20080514151407.GD6902@cvg>
 <je1w44ucrc.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008, Andreas Schwab wrote:
> Cyrill Gorcunov <gorcunov@gmail.com> writes:
> > Andreas, could you test/review the following patch
> > (what is worse - I *have* introduced buffer overflow with my
> > patch, so I think we should fix it asap)
> 
> I've compiled the file with the various cross compilers I have laying
> around here, no reference to strlen any more.

Same here. Builds and runs fine (on ARAnyM). Thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
