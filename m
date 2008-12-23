Return-Path: <linux-kernel-owner+w=401wt.eu-S1751310AbYLWLcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbYLWLcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 06:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbYLWLcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 06:32:14 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:10147 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbYLWLcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 06:32:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=e8JCAcJcVCoaxVvCVGx1dax9SOAEWExrPpk3CCsKfgmDGYz5jybFmSYfsg4q9O1HEg
         RSB9g9Bhm06ZNNS/YGxDno346w8fC/esWIAo3a6OHHcy0Xpg0W7pigAs4EhyY+mXSuw1
         8ZQ6MvQ3oJjNHVXtEVTt+qtPxMuGT9Jkly7yA=
Message-ID: <4950CC38.3090200@gmail.com>
Date: Tue, 23 Dec 2008 14:32:08 +0300
From: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071114)
MIME-Version: 1.0
To: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/4 v4] i.MX31: Image Processing Unit DMA and IRQ	drivers
References: <Pine.LNX.4.64.0812181406000.5510@axis700.grange> <Pine.LNX.4.64.0812181414280.5510@axis700.grange> <20081218225834.GJ20756@pengutronix.de> <Pine.LNX.4.64.0812221240210.5241@axis700.grange> <20081222183753.GD1614@pengutronix.de> <20081222200337.GD9472@pengutronix.de> <4950B8C6.30309@gmail.com> <20081223105246.GF1614@pengutronix.de>
In-Reply-To: <20081223105246.GF1614@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sascha Hauer wrote:
> On Tue, Dec 23, 2008 at 01:09:10PM +0300, Dmitry Krivoschekov wrote:
>> Robert Schwebel wrote:
>>> On Mon, Dec 22, 2008 at 07:37:53PM +0100, Sascha Hauer wrote:
>>>> Another thing is the overlay framebuffer. I think it's mainly useful
>>>> to display video streams.
>>> Right. The idea is that you can push a video stream into /dev/fb1 (for
>>> example by using the gstreamer fbdev sink) while displaying widgets from
>>> a GUI toolkit on /dev/fb0.
>>>
>>>> Maybe it's better to implement this as a v4l device as unlike the
>>>> framebuffer API the v4l API is designed to handle different image
>>>> buffers.
>>> Huh? v4l is image-frames-to-userspace, not vice versa.
>>>
>> ...and vice versa too, v4l2 is not about input devices only but it is
>> also related to output devices, v4l2 spec even has a special chapter
>> dedicated to overlays [1]. Moreover, you can find such a driver within
>> Freescale's BSP [2]. Another example is Omap's videoout driver [3].
>
> Are you aware of any application making use of this feature?

IIRC, mplayer is able to output on a v4l2 device. Also, Freescale's
i.MX31 ADS BSP contained a bunch of V4L2 unit tests, including v4l2 output.

Dmitry


[1]
http://www.freescale.com/webapp/sps/site/overview.jsp?code=CW_BSP_ARM&fsrch=1
>
> Sascha
>

