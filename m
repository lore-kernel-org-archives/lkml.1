Return-Path: <linux-kernel-owner+w=401wt.eu-S1758453AbXKTEIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453AbXKTEIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 23:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbXKTEIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 23:08:11 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2359 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbXKTEIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 23:08:10 -0500
Subject: Re: [v4l-dvb-maintainer] [PATCH 25/59] drivers/media/video: Add
	missing "space"
From: Joe Perches <joe@perches.com>
To: Brandon Philips <bphilips@suse.de>
Cc: linux-kernel@vger.kernel.org, Stelian Pop <stelian@popies.net>,
       "LinuxTV.org Project" <v4l-dvb-maintainer@linuxtv.org>,
       video4linux-list@redhat.com,
       Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20071120022442.GA17247@ifup.org>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
	 <8cdb362d494c702f6f0cf095e8e24435550bf5ce.1195454435.git.joe@perches.com>
	 <20071120022442.GA17247@ifup.org>
Content-Type: text/plain
Date: Mon, 19 Nov 2007 20:08:07 -0800
Message-Id: <1195531687.4675.73.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-19 at 18:24 -0800, Brandon Philips wrote:
> On 17:48 Mon 19 Nov 2007, Joe Perches wrote:
> >  		v4l_dbg(1, cx25840_debug, client, "hblank %i, hactive %i, "
> > -			"vblank %i , vactive %i, vblank656 %i, src_dec %i,"
> > +			"vblank %i , vactive %i, vblank656 %i, src_dec %i, "
> 				^^^^^
> 				can you remove that unintended

diff --git a/drivers/media/video/cx25840/cx25840-vbi.c b/drivers/media/video/cx25840/cx25840-vbi.c
index ced13fe..d2949e5 100644
--- a/drivers/media/video/cx25840/cx25840-vbi.c
+++ b/drivers/media/video/cx25840/cx25840-vbi.c
@@ -180,7 +180,7 @@ void cx25840_vbi_setup(struct i2c_client *client)
 						fsc/1000000,fsc%1000000);
 
 		v4l_dbg(1, cx25840_debug, client, "hblank %i, hactive %i, "
-			"vblank %i , vactive %i, vblank656 %i, src_dec %i,"
+			"vblank %i, vactive %i, vblank656 %i, src_dec %i, "
 			"burst 0x%02x, luma_lpf %i, uv_lpf %i, comb 0x%02x,"
 			" sc 0x%06x\n",
 			hblank, hactive, vblank, vactive, vblank656,



