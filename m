Return-Path: <linux-kernel-owner+w=401wt.eu-S933400AbXBXHCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400AbXBXHCY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 02:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933401AbXBXHCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 02:02:24 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:46766 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933400AbXBXHCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 02:02:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=n1PjCIXInpqPhpulNZQELNlPt+LWfIra+gm0KqKs3bkk58CVQCQ1c7RoNGYUebfYzP+ysrh00hLZgvsrEqPbGmAR3+iNtcLSMNzWgswmKixrVxlz8YMbLkcpoZE2i8eVks6uI7ZglCyBst3dzAHfkb5ggaWqN6TQ0IuKdLGN9Mk=
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: James Simmons <jsimmons@infradead.org>, Luca Tettamanti <kronos@people.it>,
       linux-fbdev-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <cb7bb73a0702230534o4e2c7e9frd5f2b05accf18c05@mail.gmail.com>
References: <ephv35$4i3$1@sea.gmane.org> <1172101406.4217.16.camel@daplas>
	 <cb7bb73a0702220001u6acbdd95ncdc9fad10d06b421@mail.gmail.com>
	 <1172133646.4086.5.camel@daplas>
	 <cb7bb73a0702220548s55380f7fk995726ffd349823b@mail.gmail.com>
	 <1172153358.4306.17.camel@daplas>
	 <cb7bb73a0702220755y3eb2e5b1r8e7908ae0c1720c9@mail.gmail.com>
	 <1172161290.4198.12.camel@daplas>
	 <cb7bb73a0702221108r161441ebt61886ce67746f389@mail.gmail.com>
	 <1172187249.4279.7.camel@daplas>
	 <cb7bb73a0702230534o4e2c7e9frd5f2b05accf18c05@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 24 Feb 2007 15:04:54 +0800
Message-Id: <1172300694.4109.50.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-23 at 14:34 +0100, Giuseppe Bilotta wrote:
> On 2/23/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> > On Thu, 2007-02-22 at 20:08 +0100, Giuseppe Bilotta wrote:
> > > No, it doesn't. I've tried all the methods from 640x480 to 1600x1200,
> > > and they /all/ come up snowy. This is starting to look queerer and
> > > queerer. I've also tried changing vf min and max as you suggested:
> >
> > Before we proceed, do you agree that the patch will allow you to change
> > video modes without disabling DDC support?  So this is still a valid
> > fix?
> 
> You're right, I hadn't realized that. I can now access all the sizes
> from 640 to 1600, so I would say the fix is valid.

Okay, thanks.

> 
> > When does your display become snowy? Is the snow constant or does it
> > only snow when doing heavy text operations, such as scrolling?
> 
> The snowy is constant and abundant, and it seems to be independent of
> video size (640 through 1600) and screen occupation (single prompt
> line to fullscreen mc session) and usage.
> 
> > I presume that X's nv driver or vesafb does not exhibit this problem?
> 
> X's nv gives a very clean display, /unless/ I load nvidiafb before: if
> I modprobe nvidiafb (it's a module, and it's blacklisted precisely for
> this reason), then the screen is very snowy with X's nv too.
> 

Hmm..., I really don't know how to fix this except to look at Xorg's
code and look for a difference.

Tony

