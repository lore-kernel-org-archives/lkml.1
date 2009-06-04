Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbZFDSfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbZFDSfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbZFDSfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:35:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:3497 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbZFDSfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:35:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AGLDSGhfBonOfEBMGf487EG1ydEzCAPvkyHJWl1k8sOFACmtmZbt5FTCdT44XPCsh7
         exABik2NAn3lO1dtj3mg6pQv2cLSjGXeLUMYoTEzm0fQaQwZSGAX7PC/lOgvlH93nidz
         9uS6EB5lp1x22zNx9cyFenkLPxYbxq+YppcLc=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@openedhand.com>
Subject: [PATCH 0/7] ASIC3 updates
Date: Thu,  4 Jun 2009 20:36:09 +0200
Message-Id: <1244140576-18006-1-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are a few ASIC3 updates, enabling the DS1WM (w1/master) and
SDIO/MMC (mmc/host) cells. Patch 1 adds functions to change EXTCF
and SDHWCTRL registers, which will also be needed for PCMCIA.

I tried to write the clock handling code in patch 2 in a way that should
make it easy to convert to the clk API, if we'll ever get a common struct
clk oder clkops across architectures.

Patch 5 removes the unneeded SD/SDIO controller register definitions,
since the tmio_mmc driver should take care of that.

regards
Philipp
