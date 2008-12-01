Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbYLAMwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbYLAMwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbYLAMw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:52:28 -0500
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4482 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbYLAMw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:52:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: Re: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-ng
Date: Mon, 1 Dec 2008 13:51:55 +0100
User-Agent: KMail/1.9.9
Cc: video4linux-list@redhat.com,
       "v4l-dvb maintainer list" <v4l-dvb-maintainer@linuxtv.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       davinci-linux-open-source-bounces@linux.davincidsp.com,
       Mauro Carvalho Chehab <mchehab@infradead.org>
References: <200812011246.08885.hverkuil@xs4all.nl> <200812011331.25676.laurent.pinchart@skynet.be>
In-Reply-To: <200812011331.25676.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011351.55323.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 December 2008 13:31:25 Laurent Pinchart wrote:
> On Monday 01 December 2008, Hans Verkuil wrote:
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
>
> Does linuxtv.org and Mercurial provide the necessary infrastructure
> to integrate those changes into the v4l-dvb repository while not
> pushing them upstream yet ? I'd like to see more people testing (and
> breaking and fixing :-)) your changes before they reach the mainline
> kernel.

That's basically why I want this to go into the v4l-dvb repository: this 
makes it easier for people to start working with it. It doesn't affect 
existing drivers, except for the i2c driver changes and those changes 
are just transforming a big switch to a set of functions. So I really 
consider this a pretty low-risk merge.

If someone is willing to do some testing with my tree in the next two 
weeks then I don't mind waiting, but it's been in development now from 
early September (if not earlier) and been reviewed several times. In 
addition, ivtv has been modified to work with it and that driver uses 
more sub-devices by far than any other driver.

I don't know what more I can do, to be honest.

Regards,

	Hans

>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@skynet.be>
> > Reviewed-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Reviewed-by: Andy Walls <awalls@radix.net>
> > Reviewed-by: David Brownell <david-b@pacbell.net>
> >
> > Once this is in I'll start on converting the other i2c drivers.
>
> Best regards,
>
> Laurent Pinchart



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
