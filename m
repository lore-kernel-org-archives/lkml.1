Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab0BIVQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 16:16:07 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:41384 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab0BIVQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 16:16:05 -0500
X-Auth-Info: zdf30jC0YFMuChl+NEp6cPiN6muXCxCfKzda5o4+39c=
From: Anatolij Gustschin <agust@denx.de>
To: linuxppc-dev@ozlabs.org
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org, gregkh@suse.de,
       jcrigby@gmail.com, dzu@denx.de, wd@denx.de,
       Anatolij Gustschin <agust@denx.de>
Subject: [PATCH v2 0/3] powerpc: mpc5121: PSC UART support
Date: Tue,  9 Feb 2010 22:13:49 +0100
Message-Id: <1265750032-2803-1-git-send-email-agust@denx.de>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The support for mpc5121 PSC UART currently only works with
serial console. This patch series re-enable PSC UART support for
all 12 PSCs and document added DTS bingings.

Anatolij Gustschin (3):
  serial: mpc52xx_uart: re-enable mpc5121 PSC UART support
  powerpc: doc/dts-bindings: document mpc5121 psc uart  dts-bindings
  powerpc: mpc5121: enable support for more PSC UARTs

 .../powerpc/dts-bindings/fsl/mpc5121-psc.txt       |   70 ++++++
 arch/powerpc/include/asm/mpc52xx_psc.h             |    4 +
 drivers/serial/mpc52xx_uart.c                      |  251 ++++++++++++++++++--
 3 files changed, 310 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/mpc5121-psc.txt

