Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbZFHXGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbZFHXGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 19:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbZFHXGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 19:06:22 -0400
Received: from xes-mad.com ([216.165.139.214]:50157 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457AbZFHXGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 19:06:21 -0400
From: Nate Case <ncase@xes-inc.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH next 0/2] gpio: pca953x updates
Date: Mon,  8 Jun 2009 17:51:51 -0500
Message-Id: <1244501513-19836-1-git-send-email-ncase@xes-inc.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes were needed to support PCA95xx GPIO on our PowerPC
boards.  We use both the PCA9557 and the PCA9556 (on older boards).

This should probably be for -next.

---

Nate Case (2):
    gpio: pca953x: Add support for PCA9556
    gpio: pca953x: Get platform_data from OpenFirmware

 drivers/gpio/pca953x.c |   80 +++++++++++++++++++++++++++++++++++++--
 1 files changed, 75 insertions(+), 5 deletions(-)

--
Nate Case <ncase@xes-inc.com>
