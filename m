Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYLAM1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYLAM1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYLAM1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:27:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49995 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbYLAM1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:27:21 -0500
Date: Mon, 1 Dec 2008 10:27:07 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "v4l-dvb maintainer list" <v4l-dvb-maintainer@linuxtv.org>,
       v4l <video4linux-list@redhat.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       davinci-linux-open-source-bounces@linux.davincidsp.com
Subject: Re: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-ng
Message-ID: <20081201102707.6c3ab527@pedra.chehab.org>
In-Reply-To: <200812011246.08885.hverkuil@xs4all.nl>
References: <200812011246.08885.hverkuil@xs4all.nl>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008 12:46:08 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Hi Mauro,
> 
> Please pull from http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-ng for the 
> following:
> 
> - v4l2: add v4l2_device and v4l2_subdev structs to the v4l2 framework.
> - v4l2-common: add i2c helper functions
> - cs53l32a: convert to v4l2_subdev.
> - cx25840: convert to v4l2_subdev.
> - m52790: convert to v4l2_subdev.
> - msp3400: convert to v4l2_subdev.
> - saa7115: convert to v4l2_subdev.
> - saa7127: convert to v4l2_subdev.
> - saa717x: convert to v4l2_subdev.
> - tuner: convert to v4l2_subdev.
> - upd64031a: convert to v4l2_subdev.
> - upd64083: convert to v4l2_subdev.
> - vp27smpx: convert to v4l2_subdev.
> - wm8739: convert to v4l2_subdev.
> - wm8775: convert to v4l2_subdev.
> - ivtv/ivtvfb: convert to v4l2_device/v4l2_subdev.
> 
> All points raised in reviews are addressed so I think it is time to get 
> this merged so people can start to use it.
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@skynet.be>
> Reviewed-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Reviewed-by: Andy Walls <awalls@radix.net>
> Reviewed-by: David Brownell <david-b@pacbell.net>
> 
> Once this is in I'll start on converting the other i2c drivers.

Hmm.. wouldn't this break the other drivers that use the converted i2c drivers
(for example saa7115 and msp3400 are used for other drivers, like em28xx and
bttv).


Cheers,
Mauro
