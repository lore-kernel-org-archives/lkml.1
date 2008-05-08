Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYEHH6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYEHH6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 03:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbYEHH6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 03:58:21 -0400
Received: from smtp1.kolej.mff.cuni.cz ([78.128.192.10]:51882 "EHLO
	smtp1.kolej.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbYEHH6U (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 03:58:20 -0400
X-Envelope-From: zajio1am@artax.karlin.mff.cuni.cz
Date: Thu, 8 May 2008 09:58:09 +0200
From: Ondrej Zajicek <santiago@crfreenet.org>
To: JosephChan@via.com.tw
Cc: akpm@linux-foundation.org, geert@linux-m68k.org,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 2/9] viafb: VIA Frame Buffer Device Driver
Message-ID: <20080508075809.GC11121@localhost.localdomain>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67753@exchtp03.taipei.via.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67753@exchtp03.taipei.via.com.tw>
X-Operating-System: Debian GNU/Linux 4.0 (Etch)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, May 07, 2008 at 07:09:28PM +0800, JosephChan@via.com.tw wrote:
> +u16 red256[] = {
> +	0x0, 0x0, 0x0, 0x0, 0xa800, 0xa800, 0xa800, 0xa800, 0x5400, 0x5400,
> +	0x5400, 0x5400, 0xfc00, 0xfc00, 0xfc00, 0xfc00,

...

> +u16 green256[] =
> +    { 0x0, 0x0, 0xa800, 0xa800, 0x0, 0x0, 0x5400, 0xa800, 0x5400, 0x5400,
> +	0xfc00, 0xfc00, 0x5400, 0x5400, 0xfc00, 0xfc00,

...

> +};
> +u16 blue256[] =
> +    { 0x0, 0xa800, 0x0, 0xa800, 0x0, 0xa800, 0x0, 0xa800, 0x5400, 0xfc00,
> +	0x5400, 0xfc00, 0x5400, 0xfc00, 0x5400, 0xfc00,
> +	0x0, 0x1400, 0x2000, 0x2c00, 0x3800, 0x4400, 0x5000, 0x6000,

...

> +};
> +
> +struct fb_cmap viafb_256_colors = { 0, 256, red256, green256, blue256, NULL

Standard pattern is to allocate colormap using fb_alloc_cmap(). This function
also fills colormap with common default colormap. It is unnecessary to have
another default colormap.

-- 
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."
