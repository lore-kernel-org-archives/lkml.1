Return-Path: <linux-kernel-owner+w=401wt.eu-S1758383AbXFOU53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383AbXFOU53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756366AbXFOU5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:57:21 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36298 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755720AbXFOU5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:57:20 -0400
Date: Fri, 15 Jun 2007 22:57:34 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: drivers/media/video/ivtv/ivtv-driver.c: check-after-use
Message-ID: <20070615205734.GJ3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following obvious check-after-use
in drivers/media/video/ivtv/ivtv-driver.c:

<--  snip  -->

...
static void ivtv_remove(struct pci_dev *pci_dev)
{
...
        free_irq(itv->dev->irq, (void *)itv);

        if (itv->dev) {
...

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

