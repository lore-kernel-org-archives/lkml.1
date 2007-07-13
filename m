Return-Path: <linux-kernel-owner+w=401wt.eu-S1759015AbXGMLyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015AbXGMLyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 07:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbXGMLyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 07:54:06 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:9196 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898AbXGMLyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 07:54:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=T7MWcuimdEOPHNekSuGKhx8RsQsmclfRbkNdw1zlUxmdVzt0xq9xPiCIL0SyKcTTJJ3egquccCJX5oBU8rMn+izEgPN/btP0anjxShie5lrPOiISQa+K9l/LljGCREFSZ1ycqA2h+aIGsvOXg5/RYJAef2iPXI+suVAWvaumL5U=
Subject: Re: [patch 2/4] fbdev: Add fb_append_extra_logo()
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       James Simmons <jsimmons@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net, cbe-oss-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       Geoff Levand <geoffrey.levand@am.sony.com>
In-Reply-To: <Pine.LNX.4.62.0707130857350.15603@pademelon.sonytel.be>
References: <20070710122702.765654000@pademelon.sonytel.be>
	 <20070710123540.678435000@pademelon.sonytel.be>
	 <1184285757.4566.11.camel@daplas>
	 <Pine.LNX.4.62.0707130857350.15603@pademelon.sonytel.be>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 19:53:53 +0800
Message-Id: <1184327633.4702.11.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 08:58 +0200, Geert Uytterhoeven wrote:
> On Fri, 13 Jul 2007, Antonino A. Daplas wrote:
> > On Tue, 2007-07-10 at 14:27 +0200, Geert Uytterhoeven wrote:
> > > --- a/include/linux/linux_logo.h
> > > +++ b/include/linux/linux_logo.h
> > > @@ -33,5 +33,13 @@ struct linux_logo {
> > >  };
> > >  
> > >  extern const struct linux_logo *fb_find_logo(int depth);
> > > +#if defined(CONFIG_LOGO) && defined(CONFIG_FB)
> > 
> > The CONFIG_LOGO is also probably redundant, but that's arguable.
> 
> You can have CONFIG_LOGO without CONFIG_FB (depends on FB ||
> SGI_NEWPORT_CONSOLE).
> 

Okay.

Tony 


