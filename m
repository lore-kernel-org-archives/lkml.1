Return-Path: <linux-kernel-owner+w=401wt.eu-S1763013AbZFLAEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763013AbZFLAEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 20:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbZFLAEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 20:04:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59573 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbZFLAEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 20:04:40 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, devicetree-discuss@ozlabs.org
Date: Fri, 12 Jun 2009 02:04:20 +0200
Message-Id: <1244765062-14144-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.6.3.1
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 0/2] add OF wrapper for uio-pdrv-genirq
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds an OF wrapper for the uio-pdrv-genirq driver.

Patch 1 refactors the platform driver to expose a generic probe-routine.
Patch 2 then adds the OF wrapper. Documentation for the binding is also added.
        There may be an issue with stack-usage, as noted there.

Tested on MPC5200B-based custom boards with 2.6.30.

(Note: this is not meant for the current merge window.)

Thanks,

   Wolfram

