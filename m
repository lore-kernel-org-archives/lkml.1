Return-Path: <linux-kernel-owner+w=401wt.eu-S1752521AbZFDSMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbZFDSMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbZFDSMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:12:07 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:51060 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbZFDSMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:12:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=D/h1P9AYCeBPmWCqYT8iC85nRyqlu2A4a9nuKZBJlUaHRGm42IWlEbPaqYSQI59P8s
         VvtxCqIMMk6LOxTYpfDJGHPrOzzdZumMeIm+nUa7iSNAApVXTakxwHfMi/Lae8cohhdV
         ap6VgVYRviwrNFcSEDi1APzsRB+UJ1cQWa1o8=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Molton <ian@mnementh.co.uk>, Pierre Ossman <pierre@ossman.eu>
Subject: [PATCH 0/7] ASIC3 support for tmio_mmc
Date: Thu,  4 Jun 2009 20:12:30 +0200
Message-Id: <1244139157-16404-1-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've broken the long lines in patches 1-3 and merged the fix into patch 2:
 [PATCH 1/7] MFD,mmc: tmio_mmc: make HCLK configurable (v2)
 [PATCH 2/7] mmc: tmio_mmc: add bus_shift support (v2)
 [PATCH 3/7] mmc: tmio_mmc: don't use set_irq_type (v2)
 [PATCH 4/7] mmc: tmio_mmc: correct probe return value for num_resources != 3
Also I've added three new patches for your consideration. Patch 5 delays mapping
of the SD control registers because mfd_cell->enable has to enable the RAM first.
Patch 6 fixes a bug in the SDCLK divider calculation and patch 7 finally enables
compilation of tmio_mmc for ASIC3:
 [PATCH 5/7] mmc: tmio_mmc: map SD control registers after enabling the MFD cell
 [PATCH 6/7] mmc: tmio_mmc: fix SDCLK divider setting
 [PATCH 7/7] mmc: tmio_mmc: allow compilation for ASIC3

regards
Philipp
