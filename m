Return-Path: <linux-kernel-owner+w=401wt.eu-S933449AbXBXJQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449AbXBXJQK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 04:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933453AbXBXJQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 04:16:10 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:29970 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933449AbXBXJQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 04:16:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BQHqyzEqe1tt+Enzf8BVdMPfABdV3MElBHUtlQSQjaIg3mwZjPh/X2uSZMg78uhrQHBBXrElNdTYBYUVcDp7THOvlXFSyD/ljT2DaZqkh7PKaMfmgm0H2z6Wy0RnuQGGUIPZeaYddQ/KV+d+JqDUxJzdMFzekh4Y3X8qk9k4qeY=
Message-ID: <cb7bb73a0702240116g33a9b5bv2e3668a536a70938@mail.gmail.com>
Date: Sat, 24 Feb 2007 10:16:06 +0100
From: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
Cc: "James Simmons" <jsimmons@infradead.org>,
       "Luca Tettamanti" <kronos@people.it>,
       linux-fbdev-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@osdl.org>, "Dave Airlie" <airlied@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1172300694.4109.50.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ephv35$4i3$1@sea.gmane.org> <1172133646.4086.5.camel@daplas>
	 <cb7bb73a0702220548s55380f7fk995726ffd349823b@mail.gmail.com>
	 <1172153358.4306.17.camel@daplas>
	 <cb7bb73a0702220755y3eb2e5b1r8e7908ae0c1720c9@mail.gmail.com>
	 <1172161290.4198.12.camel@daplas>
	 <cb7bb73a0702221108r161441ebt61886ce67746f389@mail.gmail.com>
	 <1172187249.4279.7.camel@daplas>
	 <cb7bb73a0702230534o4e2c7e9frd5f2b05accf18c05@mail.gmail.com>
	 <1172300694.4109.50.camel@daplas>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/24/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> On Fri, 2007-02-23 at 14:34 +0100, Giuseppe Bilotta wrote:
> >
> > The snowy is constant and abundant, and it seems to be independent of
> > video size (640 through 1600) and screen occupation (single prompt
> > line to fullscreen mc session) and usage.
> >
> > > I presume that X's nv driver or vesafb does not exhibit this problem?
> >
> > X's nv gives a very clean display, /unless/ I load nvidiafb before: if
> > I modprobe nvidiafb (it's a module, and it's blacklisted precisely for
> > this reason), then the screen is very snowy with X's nv too.
> >
>
> Hmm..., I really don't know how to fix this except to look at Xorg's
> code and look for a difference.

Keep in mind that setting nvidiafb to totally ignore the EDID (either
by not compiling in EDID support or by using e.g. the ignoreedid patch
I had proposed) the snow effect is extremely reduced, to the point of
being barely perceptible during normal usage (not as clean as X, but
still very good).

Also, I'm wondering if it might be worth looking at the progress done
in nouveau, and the drm stuff they've implemented (or at least the new
memory management and maybe some of the 2D stuff).

-- 
Giuseppe "Oblomov" Bilotta
