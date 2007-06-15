Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbXFOVA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbXFOVA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756854AbXFOVAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:00:18 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36301 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756684AbXFOVAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:00:17 -0400
Date: Fri, 15 Jun 2007 23:00:31 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Michal CIJOML Semler <cijoml@volny.cz>,
       Markus Rechberger <markus.rechberger@amd.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org
Subject: drivers/media/dvb/dvb-core/dvb_net.c: check-after-use
Message-ID: <20070615210031.GK3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following obvious check-after-use in 
drivers/media/dvb/dvb-core/dvb_net.c:

<--  snip  -->

...
static int dvb_net_close(struct inode *inode, struct file *file)
{
...
        struct dvb_net *dvbnet = dvbdev->priv;

        if (!dvbdev)
                return -ENODEV;
...

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


