Return-Path: <linux-kernel-owner+w=401wt.eu-S932817AbXBVBFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817AbXBVBFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 20:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932632AbXBVBFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 20:05:36 -0500
Received: from nz-out-0506.google.com ([64.233.162.224]:33823 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932817AbXBVBFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 20:05:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OJRt5+pbGLJpeRoeH4gHL5wG/GDyB3FD4LkV/2us3jv0/jW366wXeY3ptQaW6eCQ9HyniheEkRNTEkWeLbeqodVXMCBXMbmUdt/kFRBdwEgNFhIo0BWYguWgUGzpOwk+/sybpqo0v9YDWSKTCn9QDXyOeDyFnNduK7065uJ9fvY=
Subject: Re: [PATCH] fbdev driver for S3 Trio/Virge, updated
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: James Simmons <jsimmons@infradead.org>
Cc: Ondrej Zajicek <santiago@crfreenet.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0702220049320.17121@pentafluge.infradead.org>
References: <20070209193405.GB2637@localhost.localdomain>
	 <1172102733.4217.38.camel@daplas>
	 <Pine.LNX.4.64.0702220049320.17121@pentafluge.infradead.org>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 09:08:25 +0800
Message-Id: <1172106505.4217.54.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 00:53 +0000, James Simmons wrote:
> > > +/* image data is MSB-first, fb structure is MSB-first too */
> > > +static inline u32 expand_color(u32 c)
> > > +{
> > > +	return ((c & 1) | ((c & 2) << 7) | ((c & 4) << 14) | ((c & 8) << 21)) * 0xFF;
> > > +}
> > > +
> > > +/* s3fb_iplan_imageblit silently assumes that almost everything is 8-pixel aligned */
> > 
> > Hmn, same thing with vga16fb... Perhaps we should bring back the
> > fontwidth flag of 2.2 and 2.4 kernels.
> 
> Ug no. It is possible to get 12,6 bit width fonts working with vga 
> interleaved planes. I got it paritally working but never got back to it.
> Its in my queue of this to do. Now that I finished the display class I 
> need to get around to makeing drm/fbdev work together :-)
> 

Of course, not fontwidth exactly, but to allow the driver to specify the
alignment of the blit engine, in this case 8 pixels. I do believe X also
has similar functionality to compensate for the limitation of the
hardware.

Tony

