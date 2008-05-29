Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbYE2L2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbYE2L2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 07:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbYE2L21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 07:28:27 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:57216 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbYE2L20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 07:28:26 -0400
Date: Thu, 29 May 2008 13:28:23 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <jkosina@suse.cz>
cc: Ingo Molnar <mingo@elte.hu>, Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k libc5 regression
In-Reply-To: <Pine.LNX.4.64.0805291303030.6718@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0805291328070.2696@anakin>
References: <Pine.LNX.4.64.0805262226280.11902@anakin>
 <Pine.LNX.4.64.0805270014110.6718@jikos.suse.cz> <Pine.LNX.4.64.0805291303030.6718@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Jiri Kosina wrote:
> On Tue, 27 May 2008, Jiri Kosina wrote:
> > > So I bisected it to:
> > > commit 4cc6028d4040f95cdb590a87db478b42b8be0508
> > > Author: Jiri Kosina <jkosina@suse.cz>
> > > Date:   Wed Feb 6 22:39:44 2008 +0100
> > >     brk: check the lower bound properly
> > Indeed, this should take CONFIG_COMPAT_BRK into account. Does the patch 
> > below fix it? (assuming that you have CONFIG_COMPAT_BRK=y):
> > From: Jiri Kosina <jkosina@suse.cz>
> > brk: check lower bound properly
> [ ... ]
> 
> Geert, did you have time to verify that the patch fixes the problem for 
> you please?

Not yet. I will definitely let you know.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
