Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbZHaNJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbZHaNJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 09:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZHaNJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 09:09:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42426 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbZHaNJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 09:09:07 -0400
Date: Mon, 31 Aug 2009 10:08:55 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
       =?ISO-8859-1?B?TultZXRoIE3hcnRvbg==?= <nm127@freemail.hu>,
       "Jean-Francois Moine" <moinejf@free.fr>,
       "Thomas Kaiser" <thomas@kaiser-linux.li>, linux-media@vger.kernel.org,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND][PATCH 1/2] v4l2: modify the webcam video standard 
 handling
Message-ID: <20090831100855.677d16d6@pedra.chehab.org>
In-Reply-To: <f37f7dc3d82cf5482ba08b90bde4795c.squirrel@webmail.xs4all.nl>
References: <4A52E897.8000607@freemail.hu>
	<4A910C42.5000001@freemail.hu>
	<20090830234114.16b90c36@pedra.chehab.org>
	<200908310858.24763.laurent.pinchart@ideasonboard.com>
	<f37f7dc3d82cf5482ba08b90bde4795c.squirrel@webmail.xs4all.nl>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 31 Aug 2009 09:33:23 +0200
"Hans Verkuil" <hverkuil@xs4all.nl> escreveu:

> > TV standards only apply to analog video. Let's simply not use it for
> > digital
> > video. We don't expect drivers to implement VIDIOC_[GS]_JPEGCOMP with fake
> > values when they don't support JPEG compression, so we should not expect
> > them
> > to implement VIDIOC_[GS]_STD when they don't support analog TV.
> 
> Exactly. Work is underway to add an API for HDTV and similar digital video
> formats. But we should just freeze the v4l2_std_id API and only use it for
> the analog PAL/NTSC/SECAM type formats. This nicely corresponds with the
> underlying standards as those have been frozen as well.

Could you please point the thread where this API is being discussed

Cheers,
Mauro
