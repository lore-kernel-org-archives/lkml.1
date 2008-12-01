Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbYLAMc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbYLAMc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYLAMct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:32:49 -0500
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4857 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbYLAMct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:32:49 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-ng
Date: Mon, 1 Dec 2008 13:31:57 +0100
User-Agent: KMail/1.9.9
Cc: "v4l-dvb maintainer list" <v4l-dvb-maintainer@linuxtv.org>,
       v4l <video4linux-list@redhat.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       davinci-linux-open-source-bounces@linux.davincidsp.com
References: <200812011246.08885.hverkuil@xs4all.nl> <20081201102707.6c3ab527@pedra.chehab.org>
In-Reply-To: <20081201102707.6c3ab527@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011331.58141.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 December 2008 13:27:07 Mauro Carvalho Chehab wrote:
> On Mon, 1 Dec 2008 12:46:08 +0100
>
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Hi Mauro,
> >
> > Please pull from http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-ng for
> > the following:
> >
> > - v4l2: add v4l2_device and v4l2_subdev structs to the v4l2
> > framework. - v4l2-common: add i2c helper functions
> > - cs53l32a: convert to v4l2_subdev.
> > - cx25840: convert to v4l2_subdev.
> > - m52790: convert to v4l2_subdev.
> > - msp3400: convert to v4l2_subdev.
> > - saa7115: convert to v4l2_subdev.
> > - saa7127: convert to v4l2_subdev.
> > - saa717x: convert to v4l2_subdev.
> > - tuner: convert to v4l2_subdev.
> > - upd64031a: convert to v4l2_subdev.
> > - upd64083: convert to v4l2_subdev.
> > - vp27smpx: convert to v4l2_subdev.
> > - wm8739: convert to v4l2_subdev.
> > - wm8775: convert to v4l2_subdev.
> > - ivtv/ivtvfb: convert to v4l2_device/v4l2_subdev.
> >
> > All points raised in reviews are addressed so I think it is time to
> > get this merged so people can start to use it.
> >
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@skynet.be>
> > Reviewed-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Reviewed-by: Andy Walls <awalls@radix.net>
> > Reviewed-by: David Brownell <david-b@pacbell.net>
> >
> > Once this is in I'll start on converting the other i2c drivers.
>
> Hmm.. wouldn't this break the other drivers that use the converted
> i2c drivers (for example saa7115 and msp3400 are used for other
> drivers, like em28xx and bttv).

No, see v4l2_subdev_command() in v4l2-subdev.c: this adds the required 
backwards compatibility. It can be removed once everyone uses the new 
calling convention, but until that time it will take care of this. 
That's the nice thing about it: you can do the conversion step by step 
without worrying about breaking existing drivers.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
