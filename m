Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbYLWKw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbYLWKw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 05:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbYLWKws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 05:52:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33146 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbYLWKwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 05:52:47 -0500
Date: Tue, 23 Dec 2008 11:52:46 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/4 v4] i.MX31: Image Processing Unit DMA and IRQ
	drivers
Message-ID: <20081223105246.GF1614@pengutronix.de>
Mail-Followup-To: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@vger.kernel.org,
	linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Dan Williams <dan.j.williams@intel.com>
References: <Pine.LNX.4.64.0812181406000.5510@axis700.grange> <Pine.LNX.4.64.0812181414280.5510@axis700.grange> <20081218225834.GJ20756@pengutronix.de> <Pine.LNX.4.64.0812221240210.5241@axis700.grange> <20081222183753.GD1614@pengutronix.de> <20081222200337.GD9472@pengutronix.de> <4950B8C6.30309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4950B8C6.30309@gmail.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 11:51:18 up 9 days, 15:18,  9 users,  load average: 0.04, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 01:09:10PM +0300, Dmitry Krivoschekov wrote:
> Robert Schwebel wrote:
> > On Mon, Dec 22, 2008 at 07:37:53PM +0100, Sascha Hauer wrote:
> >> Another thing is the overlay framebuffer. I think it's mainly useful
> >> to display video streams.
> >
> > Right. The idea is that you can push a video stream into /dev/fb1 (for
> > example by using the gstreamer fbdev sink) while displaying widgets from
> > a GUI toolkit on /dev/fb0.
> >
> >> Maybe it's better to implement this as a v4l device as unlike the
> >> framebuffer API the v4l API is designed to handle different image
> >> buffers.
> >
> > Huh? v4l is image-frames-to-userspace, not vice versa.
> >
> ...and vice versa too, v4l2 is not about input devices only but it is
> also related to output devices, v4l2 spec even has a special chapter
> dedicated to overlays [1]. Moreover, you can find such a driver within
> Freescale's BSP [2]. Another example is Omap's videoout driver [3].

Are you aware of any application making use of this feature?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
