Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbYKRH5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbYKRH5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbYKRH4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:56:20 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:11095 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbYKRH4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:56:19 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62690617"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Introduce SPI locking bus interface to SPI framework
Date: Tue, 18 Nov 2008 15:57:45 +0800
Message-Id: <1226995067-4484-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Dave,

Yi introduced SPI locking bus interface to SPI framework. This is
required by some SPI devices in bus sharing situation, for example,
the MMC card driver over SPI.

We also use this API in our Blackfin SPI master driver and tested on
our own MMC over SPI driver. Since that MMC over SPI driver is different
with the mainline version, we will try to bring up the MMC_SPI driver by
adding these new SPI locking bus API.

Please kindly review.

Thanks
-Bryan
