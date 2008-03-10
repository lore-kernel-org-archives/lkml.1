Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbYCJIRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbYCJIRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 04:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYCJIQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 04:16:43 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:37352 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYCJIQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 04:16:42 -0400
Date: Mon, 10 Mar 2008 09:16:34 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-fbdev-devel@lists.sourceforge.net
cc: Ondrej Zajicek <santiago@crfreenet.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 1/4] gxfb: Replace FBSIZE config
 option with a kernel argument
In-Reply-To: <20080309195754.6d972be7@ephemeral>
Message-ID: <Pine.LNX.4.64.0803100915300.8567@anakin>
References: <20080223011045.48e6cb8e@ephemeral> <20080227163105.e1b96023.akpm@linux-foundation.org>
 <20080227195839.1e86074e@ephemeral> <20080308201950.28f6eae8@ephemeral>
 <20080309220025.GD9971@localhost.localdomain> <20080309195754.6d972be7@ephemeral>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008, Andres Salomon wrote:
> On Sun, 9 Mar 2008 23:00:25 +0100
> Ondrej Zajicek <santiago@crfreenet.org> wrote:
> 
> > On Sat, Mar 08, 2008 at 08:19:50PM -0500, Andres Salomon wrote:
> > > > assuming this is historical at this point, and manual options parsing can
> > > > be removed from all fb drivers at this point, or is there another reason
> > > > why manual parsing would be necessary?
> > > > 
> > > 
> > > Could I get an answer from the fbdevel folks about this?  It looks like
> > > the fb_get_options stuff is there for backwards compatibility.
> > 
> > I think so. I used fb_get_options() in arkfb and vt8623fb for mode option
> > only. Universal notation module.option=value is much nicer than manual
> > options parsing.  

This `module.option=value' is a quite recent introduction? I first saw it
mentioned earlier this year...

> If that is indeed the case, here's a patch that might be useful.  I have
> no idea what kind of timeframe would be proposed for removing
> fb_get_options (or if it's even desirable to remove it at all given that
> people are likely still using video=$foo syntax).

Probably it's way too early for that...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
