Return-Path: <linux-kernel-owner+w=401wt.eu-S964969AbXBYNQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964969AbXBYNQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 08:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964962AbXBYNQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 08:16:59 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:5959 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964964AbXBYNQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 08:16:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Du98AIpCxx3xO4DVXJzCId+eNU/to4tycWONIHpO9DUEzxsMuXXgSAlXpRsHKlVIrPb9AjkDwKAA+CoAUqDC6bYpPgDhpx76wNGnKHYNepgMpwzJIYn4Oay91MeHnZcluMsWst5MdENdXk1uMr5GdcBuIkb9AfLJDhW+8zHUVCw=
Message-ID: <cb7bb73a0702250516p4e64ec64ueca3128f752bb421@mail.gmail.com>
Date: Sun, 25 Feb 2007 14:16:55 +0100
From: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
Cc: "James Simmons" <jsimmons@infradead.org>,
       "Luca Tettamanti" <kronos@people.it>,
       linux-fbdev-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@osdl.org>, "Dave Airlie" <airlied@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1172401825.6187.2.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ephv35$4i3$1@sea.gmane.org> <1172161290.4198.12.camel@daplas>
	 <cb7bb73a0702221108r161441ebt61886ce67746f389@mail.gmail.com>
	 <1172187249.4279.7.camel@daplas>
	 <cb7bb73a0702230534o4e2c7e9frd5f2b05accf18c05@mail.gmail.com>
	 <1172300694.4109.50.camel@daplas>
	 <cb7bb73a0702240116g33a9b5bv2e3668a536a70938@mail.gmail.com>
	 <1172351769.4415.5.camel@daplas>
	 <cb7bb73a0702250226k53369655vc9c4e5a71c337a8c@mail.gmail.com>
	 <1172401825.6187.2.camel@daplas>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/25/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> On Sun, 2007-02-25 at 11:26 +0100, Giuseppe Bilotta wrote:
> >
> > Applied. No noticeable difference, in the sense that the EDID debug
> > output is still the same and so is the snow effect.
>
> Here's a temporary workaround:
>
> In drivers/video/nvidia/nv_i2c.c:nvidia_probe_i2c_connector(),comment
> this out:
>
>         if (par->chan[conn - 1].par)
>                 edid = fb_ddc_read(&par->chan[conn - 1].adapter);
>
> and make sure CONFIG_FIRMWARE_EDID=y.

With this patch, I don't get any dmesg info about my monitor EDID, but
I still get the snow. Could it be that there's something else on my
system which is setting the video to some absurd timings when I
switchg on the framebuffer console? I'm running an up-to-date debian
unstable.

-- 
Giuseppe "Oblomov" Bilotta
