Return-Path: <linux-kernel-owner+w=401wt.eu-S1752038AbXBVXbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbXBVXbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 18:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbXBVXbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 18:31:36 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:38380 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbXBVXbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 18:31:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=U8CWHcN4bruj4F0LuUFcpVM6Kv3pwVOTmTiEMW2p/pzxVMrjlt8COFBYkvidNApFJwLQNfUopYoP7vumzz6p6IF5jjuIz9rEPPvlh8u+v7HqkPelQIp2i22HuwA1PriO0k562go0W+9CGJUUy0QB0IevUeaQy33S/Ypg3jRKtzg=
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: James Simmons <jsimmons@infradead.org>, Luca Tettamanti <kronos@people.it>,
       linux-fbdev-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <cb7bb73a0702221108r161441ebt61886ce67746f389@mail.gmail.com>
References: <ephv35$4i3$1@sea.gmane.org>
	 <Pine.LNX.4.64.0702062034380.9224@pentafluge.infradead.org>
	 <cb7bb73a0702061508x767882dcia1b13f85d898b6e7@mail.gmail.com>
	 <1172101406.4217.16.camel@daplas>
	 <cb7bb73a0702220001u6acbdd95ncdc9fad10d06b421@mail.gmail.com>
	 <1172133646.4086.5.camel@daplas>
	 <cb7bb73a0702220548s55380f7fk995726ffd349823b@mail.gmail.com>
	 <1172153358.4306.17.camel@daplas>
	 <cb7bb73a0702220755y3eb2e5b1r8e7908ae0c1720c9@mail.gmail.com>
	 <1172161290.4198.12.camel@daplas>
	 <cb7bb73a0702221108r161441ebt61886ce67746f389@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 23 Feb 2007 07:34:09 +0800
Message-Id: <1172187249.4279.7.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 20:08 +0100, Giuseppe Bilotta wrote:
> On 2/22/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> > On Thu, 2007-02-22 at 16:55 +0100, Giuseppe Bilotta wrote:
> > >
> > > However, I'm still getting the same snowy effects, which doesn't come
> > > as a surprise since the actual mode timings used are just the same ...
> >
> > Yes, because the EDID has only 1 mode entry. But now you can use 'fbset
> > 1024x768-60' (or any mode smaller than 1600x1200-60) for example and it
> > should work.
> 
> No, it doesn't. I've tried all the methods from 640x480 to 1600x1200,
> and they /all/ come up snowy. This is starting to look queerer and
> queerer. I've also tried changing vf min and max as you suggested:

Before we proceed, do you agree that the patch will allow you to change
video modes without disabling DDC support?  So this is still a valid
fix?

> 
> >  You might want to change  vfmin and vfmax to 59 and 61
> 
> and even the M and MR methods which you suggested in the other email.
> Since nvidiafb is being loaded from the command line because it's a
> blacklisted module otherwise, I've been using the mode_option option.
> However, neither the mode_option nor fbset seem to give me anything
> not snowy.

When does your display become snowy? Is the snow constant or does it
only snow when doing heavy text operations, such as scrolling?

I presume that X's nv driver or vesafb does not exhibit this problem?

Tony


