Return-Path: <linux-kernel-owner+w=401wt.eu-S947076AbXHMOlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S947076AbXHMOlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970668AbXHMLm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:42:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43545 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970569AbXHMLmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:42:55 -0400
Subject: Re: [v4l-dvb-maintainer] [PATCH] [165/2many] MAINTAINERS - DVB
	SUBSYSTEM AND DRIVERS
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: joe@perches.com
Cc: v4l-dvb-maintainer@linuxtv.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <46bff9a0.e/9yM2yHeGs6e+wx%joe@perches.com>
References: <46bff9a0.e/9yM2yHeGs6e+wx%joe@perches.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 13 Aug 2007 08:42:42 -0300
Message-Id: <1187005362.7067.15.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1-1mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Em Dom, 2007-08-12 às 23:26 -0700, joe@perches.com escreveu:
>  DVB SUBSYSTEM AND DRIVERS

> +F:	drivers/media/video/*/*dvb.c
> +F:	drivers/media/video/*dvb.c

Those refers to the files:
	drivers/media/video/video-buf-dvb.c
	drivers/media/video/cx88/cx88-dvb.c
	drivers/media/video/saa7134/saa7134-dvb.c

You should remove those patterns. Those are maintainted together with
VIDEO4LINUX, since they are part of cx88 and saa7134 drivers.

You should also add this entry to DVB:

+F: linux/drivers/media/common/saa7146*.c
 
Cheers,
Mauro

