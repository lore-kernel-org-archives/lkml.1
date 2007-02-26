Return-Path: <linux-kernel-owner+w=401wt.eu-S965254AbXBZMoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965254AbXBZMoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 07:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965253AbXBZMoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 07:44:12 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:33365 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965254AbXBZMoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 07:44:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kdFh8XdlWOQIsxJ5BwK0AnsLYj8BWV8GbETv/JbsvfU/IjUE3ifd0xYiejQQz3/QmdcmqV3mzL+iwKvACW1YAcDEHZOTcbAo10KrsyzgzaVthm4cVKEqfbULj3cL1wS/nO9EETlDA5ZL2xBoM9VG8OOLkyQ+I8Y93jKYPqq02CQ=
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: James Simmons <jsimmons@infradead.org>, Luca Tettamanti <kronos@people.it>,
       linux-fbdev-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <cb7bb73a0702250516p4e64ec64ueca3128f752bb421@mail.gmail.com>
References: <ephv35$4i3$1@sea.gmane.org> <1172161290.4198.12.camel@daplas>
	 <cb7bb73a0702221108r161441ebt61886ce67746f389@mail.gmail.com>
	 <1172187249.4279.7.camel@daplas>
	 <cb7bb73a0702230534o4e2c7e9frd5f2b05accf18c05@mail.gmail.com>
	 <1172300694.4109.50.camel@daplas>
	 <cb7bb73a0702240116g33a9b5bv2e3668a536a70938@mail.gmail.com>
	 <1172351769.4415.5.camel@daplas>
	 <cb7bb73a0702250226k53369655vc9c4e5a71c337a8c@mail.gmail.com>
	 <1172401825.6187.2.camel@daplas>
	 <cb7bb73a0702250516p4e64ec64ueca3128f752bb421@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 20:46:25 +0800
Message-Id: <1172493985.20842.11.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-25 at 14:16 +0100, Giuseppe Bilotta wrote:
> On 2/25/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> > On Sun, 2007-02-25 at 11:26 +0100, Giuseppe Bilotta wrote:
> > >
> > > Applied. No noticeable difference, in the sense that the EDID debug
> > > output is still the same and so is the snow effect.
> >
> > Here's a temporary workaround:
> >
> > In drivers/video/nvidia/nv_i2c.c:nvidia_probe_i2c_connector(),comment
> > this out:
> >
> >         if (par->chan[conn - 1].par)
> >                 edid = fb_ddc_read(&par->chan[conn - 1].adapter);
> >
> > and make sure CONFIG_FIRMWARE_EDID=y.
> 
> With this patch, I don't get any dmesg info about my monitor EDID, but
> I still get the snow. Could it be that there's something else on my
> system which is setting the video to some absurd timings when I
> switchg on the framebuffer console? I'm running an up-to-date debian
> unstable.
> 

At this point, I don't know.  You're the first person to report this
kind of problem. I'm still studying the nvidiafb and Xorg source code.

Tony

