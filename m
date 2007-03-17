Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbXCQUFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbXCQUFa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 16:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbXCQUF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 16:05:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56313 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbXCQUF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 16:05:29 -0400
Subject: Re: Porting V4L2 drivers to 2.6.20
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: Maximus <john.maximus@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200703131108.03090.laurent.pinchart@skynet.be>
References: <3634de740703130300j12928fbeob860c067e46badbf@mail.gmail.com>
	 <200703131108.03090.laurent.pinchart@skynet.be>
Content-Type: text/plain; charset=utf-8
Date: Sat, 17 Mar 2007 18:05:21 -0200
Message-Id: <1174161921.4419.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0-1mdv2007.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Ter, 2007-03-13 às 11:08 +0100, Laurent Pinchart escreveu:
> > Hey,
> >          am porting V4L2 drivers from 2.6.13 to 2.6.20.
> >
> >      The driver is using a  structure 'video_device' which exists in
> > include/linux/videodev.h.
> >
> >      However, The linux kernel in 2.6.20 doesnot have that structure?.
> >
> >       Has the architecture changed between 2.6.13 to 2.6.20 for V4L2?.
> 
> The structure has been moved to include/media/v4l2-dev.h

Yes.

You should notice that, if you want to send those drivers to kernel
mainstream, they should also be ported to V4L2 API (since V4L1 API is
obsolete). So, you shouldn't include linux/videodev.h, but, instead,
linux/videodev2.h for v4l2 API (and v4l2-dev.h for the internal V4L2
structures). Also, please c/c me on v4l kernel patches submission, since
I'm the V4L maintainer.

Cheers,
Mauro.
> 
> Best regards,
> 
> Laurent Pinchart
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Cheers,
Mauro

