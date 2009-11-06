Return-Path: <linux-kernel-owner+w=401wt.eu-S1757470AbZKFLqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470AbZKFLqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 06:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757063AbZKFLqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 06:46:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48655 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756927AbZKFLqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 06:46:17 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 0/2] Still not applied (resending again)
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 06 Nov 2009 11:32:29 +0000
Message-ID: <20091106113159.14699.16040.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regression fixes for the carrier handling when using O_NDELAY
---

Alan Cox (2):
      tty_port: If we are opened non blocking we still need to raise the carrier
      cp210x: Fix carrier handling


 drivers/char/tty_port.c     |   10 ++++++++--
 drivers/usb/serial/cp210x.c |   21 +++++++++++++++++++++
 2 files changed, 29 insertions(+), 2 deletions(-)

-- 
