Return-Path: <linux-kernel-owner+w=401wt.eu-S1752266AbYJOHvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbYJOHvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 03:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYJOHux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 03:50:53 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:41470 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbYJOHuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 03:50:52 -0400
Date: Wed, 15 Oct 2008 09:50:45 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 17/18] net/rfkill/rfkill-input.c needs <linux/sched.h>
In-Reply-To: <20081015031018.GA25190@khazad-dum.debian.net>
Message-ID: <Pine.LNX.4.64.0810150950000.25759@anakin>
References: <20081013195846.674654386@mail.of.borg> <20081013195922.392078574@mail.of.borg>
 <20081013204559.GC28597@khazad-dum.debian.net> <Pine.LNX.4.64.0810140920320.6220@anakin>
 <20081015031018.GA25190@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008, Henrique de Moraes Holschuh wrote:
> On Tue, 14 Oct 2008, Geert Uytterhoeven wrote:
> > Unfortunately that's not possible, due to Include Hell(tm).
> > Therefore, including <linux/sched.h> is the way this has been fixed in
> > the past.
> 
> I see.  Well, when doing this I'd suggest adding a comment, otherwise the
> include could end up getting removed sooner or later without anyone asking
> linux-m68k first (I seriously douby anyone will do git blame to find out why
> an #include line exists before removing it).
> 
> Something like:
> #include <sched.h> /* m68k needs task_struct for <whatever> */

Probably we should start looking again into extracting struct
task_struct into its own header file, cfr. what Roman Zippel did a long
time ago...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
