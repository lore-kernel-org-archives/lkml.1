Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbXGIRZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbXGIRZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 13:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbXGIRZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 13:25:09 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:55750 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753868AbXGIRZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 13:25:07 -0400
Date: Mon, 9 Jul 2007 19:25:39 +0200
From: Adrian Bunk <bunk@stusta.de>
To: samuel@sortiz.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: RFC: removing DONGLE_OLD drivers?
Message-ID: <20070709172539.GF3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With one exception, all DONGLE_OLD drivers have newer counterparts.

The DONGLE_OLD drivers depend on BROKEN_ON_SMP which e.g. implies that 
the many distributions shipping only SMP-kernels will never offer them.

The one exception is a driver for the Cirrus Logic EDB-7211 evaluation 
board that itself is out of production for some years.

Can we remove these old drivers or is there a good reason for keeping 
them?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

