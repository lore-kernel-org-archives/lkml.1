Return-Path: <linux-kernel-owner+w=401wt.eu-S1751376AbXBVAyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbXBVAyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 19:54:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbXBVAyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 19:54:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53569 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbXBVAyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 19:54:09 -0500
Date: Thu, 22 Feb 2007 00:53:53 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: "Antonino A. Daplas" <adaplas@gmail.com>
cc: Ondrej Zajicek <santiago@crfreenet.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] fbdev driver for S3 Trio/Virge, updated
In-Reply-To: <1172102733.4217.38.camel@daplas>
Message-ID: <Pine.LNX.4.64.0702220049320.17121@pentafluge.infradead.org>
References: <20070209193405.GB2637@localhost.localdomain> <1172102733.4217.38.camel@daplas>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > +/* image data is MSB-first, fb structure is MSB-first too */
> > +static inline u32 expand_color(u32 c)
> > +{
> > +	return ((c & 1) | ((c & 2) << 7) | ((c & 4) << 14) | ((c & 8) << 21)) * 0xFF;
> > +}
> > +
> > +/* s3fb_iplan_imageblit silently assumes that almost everything is 8-pixel aligned */
> 
> Hmn, same thing with vga16fb... Perhaps we should bring back the
> fontwidth flag of 2.2 and 2.4 kernels.

Ug no. It is possible to get 12,6 bit width fonts working with vga 
interleaved planes. I got it paritally working but never got back to it.
Its in my queue of this to do. Now that I finished the display class I 
need to get around to makeing drm/fbdev work together :-)

