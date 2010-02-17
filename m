Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab0BQU7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 15:59:48 -0500
Received: from mail.gmx.net ([213.165.64.20]:33522 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756215Ab0BQU7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 15:59:47 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18ERKU45aIEpA2XIZuk8XR0FYfN0E+beT0TKWtRjq
	5YJRRrkKiKikPk
Date: Wed, 17 Feb 2010 21:59:22 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Media Mailing List <linux-media@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] V4L/DVB: v4l: document new Bayer and monochrome
 pixel formats
In-Reply-To: <4B7C239D.6010609@redhat.com>
Message-ID: <Pine.LNX.4.64.1002172153020.4623@axis700.grange>
References: <4B7C239D.6010609@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010, Mauro Carvalho Chehab wrote:

> Document all four 10-bit Bayer formats, 10-bit monochrome and a missing
> 8-bit Bayer formats.
> 
> [mchehab@redhat.com: remove duplicated symbol for V4L2-PIX-FMT-SGRBG10]
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  Documentation/DocBook/Makefile               |    3 +
>  Documentation/DocBook/v4l/pixfmt-srggb10.xml |   90 ++++++++++++++++++++++++++
>  Documentation/DocBook/v4l/pixfmt-srggb8.xml  |   67 +++++++++++++++++++
>  Documentation/DocBook/v4l/pixfmt-y10.xml     |   79 ++++++++++++++++++++++
>  Documentation/DocBook/v4l/pixfmt.xml         |    8 +--
>  5 files changed, 242 insertions(+), 5 deletions(-)
>  create mode 100644 Documentation/DocBook/v4l/pixfmt-srggb10.xml
>  create mode 100644 Documentation/DocBook/v4l/pixfmt-srggb8.xml
>  create mode 100644 Documentation/DocBook/v4l/pixfmt-y10.xml
> 
> diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
> index 65deaba..1c796fc 100644
> --- a/Documentation/DocBook/Makefile
> +++ b/Documentation/DocBook/Makefile
> @@ -309,6 +309,9 @@ V4L_SGMLS = \
>  	v4l/pixfmt-yuv422p.xml \
>  	v4l/pixfmt-yuyv.xml \
>  	v4l/pixfmt-yvyu.xml \
> +	v4l/pixfmt-srggb10.xml \
> +	v4l/pixfmt-srggb8.xml \
> +	v4l/pixfmt-y10.xml \

Mauro, why didn't you put them next to similar formats, as in my original 
patch?

>  	v4l/pixfmt.xml \
>  	v4l/vidioc-cropcap.xml \
>  	v4l/vidioc-dbg-g-register.xml \

Thanks
Guennadi
---
Guennadi Liakhovetski
