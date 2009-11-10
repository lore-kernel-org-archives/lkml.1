Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342AbZKJJM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbZKJJM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 04:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbZKJJM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 04:12:27 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34856 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbZKJJMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 04:12:25 -0500
From: Luotao Fu <l.fu@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       l.fu@pengutronix.de
Subject: Patches for mpc52xx_spi
Date: Tue, 10 Nov 2009 10:12:06 +0100
Message-Id: <1257844329-20687-1-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Grant,

here are several patches for the dedicated spi controller on mpc5200 SOC. The
patchset contains two fixes and an enhancement. I noticed that your original V4
Patch is still pending for mainline. So I made the patches against the latest
version in your -next tree. Tested on a mpc5200b machine with 7 spi devices,
(cs lines are conntected to gpios) on 2.6.31, should work with latest kernel
also. Please review.

cheers
Luotao Fu
