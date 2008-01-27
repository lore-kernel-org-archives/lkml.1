Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbYA0SwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbYA0SwF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 13:52:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbYA0Svz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 13:51:55 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:34848 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbYA0Svy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:51:54 -0500
Date: Sun, 27 Jan 2008 20:52:16 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: 2.6.25 regression: VIDEO_DEV=y/m, I2C=n compile error
Message-ID: <20080127185216.GB13300@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8ffbc6559493c64d6194c92d856196fdaeb8a5fb causes the following 
compile error with CONFIG_VIDEO_DEV=y/m, CONFIG_I2C=n:

<--  snip  -->

...
  MODPOST 26 modules
ERROR: "i2c_attach_client" [drivers/media/video/v4l2-common.ko] undefined!
make[2]: *** [__modpost] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

