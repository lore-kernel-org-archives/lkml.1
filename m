Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbYLWKJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbYLWKJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 05:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbYLWKJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 05:09:24 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:5362 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbYLWKJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 05:09:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=THGnxaHc4/SSiJKq2LS5faRwPnqzaG8PCjRsaUwMTUUBs6mdaB6f0u6ItmdZxLdu9O
         6GFtGALUsZAa6E1kGHpkoBG/tWPDtIpviFHhjlpbpHH/FI2yfIG6+Qtwetb2LuDWZ+As
         5rgLMQdrbgno9445LD/Ei9dWVSvvHBhFroN+w=
Message-ID: <4950B8C6.30309@gmail.com>
Date: Tue, 23 Dec 2008 13:09:10 +0300
From: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071114)
MIME-Version: 1.0
To: Robert Schwebel <r.schwebel@pengutronix.de>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/4 v4] i.MX31: Image Processing Unit DMA and IRQ	drivers
References: <Pine.LNX.4.64.0812181406000.5510@axis700.grange> <Pine.LNX.4.64.0812181414280.5510@axis700.grange> <20081218225834.GJ20756@pengutronix.de> <Pine.LNX.4.64.0812221240210.5241@axis700.grange> <20081222183753.GD1614@pengutronix.de> <20081222200337.GD9472@pengutronix.de>
In-Reply-To: <20081222200337.GD9472@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Schwebel wrote:
> On Mon, Dec 22, 2008 at 07:37:53PM +0100, Sascha Hauer wrote:
>> Another thing is the overlay framebuffer. I think it's mainly useful
>> to display video streams.
>
> Right. The idea is that you can push a video stream into /dev/fb1 (for
> example by using the gstreamer fbdev sink) while displaying widgets from
> a GUI toolkit on /dev/fb0.
>
>> Maybe it's better to implement this as a v4l device as unlike the
>> framebuffer API the v4l API is designed to handle different image
>> buffers.
>
> Huh? v4l is image-frames-to-userspace, not vice versa.
>
...and vice versa too, v4l2 is not about input devices only but it is
also related to output devices, v4l2 spec even has a special chapter
dedicated to overlays [1]. Moreover, you can find such a driver within
Freescale's BSP [2]. Another example is Omap's videoout driver [3].


Dmitry

[1]http://v4l2spec.bytesex.org/spec-single/v4l2.html#OVERLAY
[2]http://opensource.freescale.com/git?p=linux-2.6-mx.git;a=blob;f=drivers/media/video/mxc/output/mxc_v4l2_output.c;h=309700bb9d1f3b3f9dcac8a48a16d0775b8ed93a;hb=refs/heads/bsp-imx31ads-rel5
[3]http://git.omapzoom.org/?p=omapkernel.git;a=blob;f=drivers/media/video/omap/omap24xxvout.c;h=25ac1319bae58751cd1a543aa0f320159e10a475;hb=HEAD

