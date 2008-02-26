Return-Path: <linux-kernel-owner+w=401wt.eu-S1765828AbYBZVgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765828AbYBZVgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763439AbYBZVg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:36:28 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:40748 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763160AbYBZVg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:36:27 -0500
Date: Tue, 26 Feb 2008 22:36:23 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Antonino Daplas <adaplas@gmail.com>
Subject: Re: [Linux-fbdev-devel] [PATCH] fbcon: replace mono_col macro with
 static inline
In-Reply-To: <1204059074.5582.35.camel@brick>
Message-ID: <Pine.LNX.4.64.0802262235150.22486@anakin>
References: <1203963237.5582.4.camel@brick> <Pine.LNX.4.64.0802260917410.5158@anakin>
 <1204059074.5582.35.camel@brick>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Harvey Harrison wrote:
> On Tue, 2008-02-26 at 09:18 +0100, Geert Uytterhoeven wrote:
> > On Mon, 25 Feb 2008, Harvey Harrison wrote:
> > > +static inline int mono_col(struct fb_info *info)
> >                               ^^^^^^^^^^^^^^^^^^^^
> > const struct fb_info *info?
> 
> I suppose, but seeing as it's an inline, does it really matter?

Sure, if one day a new routine calls mono_col() passing a const struct fb_info
pointer, it won't compile.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
