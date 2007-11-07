Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbXKGR6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbXKGR6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759045AbXKGR55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:57:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51088 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758881AbXKGR54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:57:56 -0500
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <47304694.2040904@gmail.com>
References: <300725321593711206@pripojeni.net>
	 <20071105234017.fcc10791.akpm@linux-foundation.org>
	 <47304694.2040904@gmail.com>
Content-Type: text/plain
Date: Wed, 07 Nov 2007 15:57:37 -0200
Message-Id: <1194458257.11579.21.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.1-1mdv2008.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Seem that something in git-dvb (or mainline) broke this driver:
> > 
> > drivers/media/video/stk11xx-core.c: In function 'show_contrast':
> > drivers/media/video/stk11xx-core.c:707: warning: initialization from incompatible pointer type
> > drivers/media/video/stk11xx-core.c: In function 'show_whitebalance':
> > drivers/media/video/stk11xx-core.c:714: warning: initialization from incompatible pointer type
> > drivers/media/video/stk11xx-core.c: In function 'stk11xx_create_sysfs_file':
> > drivers/media/video/stk11xx-core.c:727: warning: passing argument 1 of 'class_device_create_file' from incompatible pointer type
> > drivers/media/video/stk11xx-core.c: In function 'stk11xx_usb_disconnect':
> > drivers/media/video/stk11xx-core.c:851: warning: passing argument 1 of 'class_device_remove_file' from incompatible pointer type
> > drivers/media/video/stk11xx-core.c:853: warning: passing argument 1 of 'class_device_remove_file' from incompatible pointer type

Those breakages were caused by some changes at sysfs that happened in
mainstream.

> > Also, please ask the v4l/dvb guys to look at this driver - there's not a lot
> > of point in sending it just to me.
> 
> Dvb fellows reviewed it some time ago, but the problem is, that it converts
> one color space to another in kernelspace. We are developping an userspace
> library for drivers such this one, but it takes longer than I expect. Lets
> have it dropped, after the library will be done I'll merge it through v4l tree.

Seems the proper way also to me.

-- 
Cheers,
Mauro

