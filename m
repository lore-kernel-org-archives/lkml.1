Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbYGOPZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbYGOPZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbYGOPY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:24:56 -0400
Received: from multi.imgtec.com ([194.200.65.239]:64052 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbYGOPYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:24:54 -0400
From: Will Newton <will.newton@imgtec.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, leoli@freescale.com, tanya.jiang@freescale.com,
       gregkh@suse.de, Will Newton <will.newton@gmail.com>
Subject: [PATCH 00/11] fsl_usb2_udc: A number of bug fixes and cleanups.
Date: Tue, 15 Jul 2008 16:24:39 +0100
Message-Id: <1216135490-21656-1-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
X-OriginalArrivalTime: 15 Jul 2008 15:24:52.0652 (UTC) FILETIME=[EDA076C0:01C8E68E]
X-SEF-Processed: 6_0_1_111__2008_07_15_16_24_53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Newton <will.newton@gmail.com>

Hi,

These patches fix a couple of small bugs and cleanup parts of the
fsl_usb2_udc USB gadget driver. I've split them up quite finely for ease
of reviewing and to separate functional changes. Any comments would be
appreciated.

I would also appreciate it if someone with real Freescale hardware could
test these changes, I'm testing this driver with a different SoC containing
the same TDI/ARC/ChipIdea IP block.

Thanks,

Will Newton (11):
  fsl_usb2_udc: Make dr_ep_setup function static.
  fsl_usb2_udc: Remove check for udc == NULL in dr_controller_setup.
  fsl_usb2_udc: Fix some sparse warnings and remove redundant code.
  fsl_usb2_udc: Clean up whitespace in errors and warnings.
  fsl_usb2_udc: Clean up whitespace in /proc debugging output.
  fsl_usb2_udc: Initialize spinlock earlier.
  fsl_usb2_udc: Rename the arguments of the fsl_writel macro.
  fsl_usb2_udc: Uninline udc_reset_ep_queue.
  fsl_usb2_udc: Make fsl_queue_td return type void.
  fsl_usb2_udc: Add a wmb before priming endpoint.
  fsl_usb2_udc: Fix oops on probe failure.

 drivers/usb/gadget/fsl_usb2_udc.c |  176 ++++++++++++++++--------------------
 drivers/usb/gadget/fsl_usb2_udc.h |   21 +----
 2 files changed, 80 insertions(+), 117 deletions(-)

