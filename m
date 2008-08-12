Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbYHLOjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbYHLOjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYHLOjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:39:21 -0400
Received: from multi.imgtec.com ([194.200.65.239]:20506 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbYHLOjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:39:20 -0400
From: Will Newton <will.newton@imgtec.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       leoli@freescale.com, Will Newton <will.newton@gmail.com>
Subject: [PATCH 00/11] fsl_usb2_udc: A number of bug fixes and cleanups.
Date: Tue, 12 Aug 2008 15:39:06 +0100
Message-Id: <1218551957-17091-1-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
X-OriginalArrivalTime: 12 Aug 2008 14:39:17.0712 (UTC) FILETIME=[330ABD00:01C8FC89]
X-SEF-Processed: 6_0_1_111__2008_08_12_15_39_18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Newton <will.newton@gmail.com>

Hi,

These patches fix a couple of small bugs and clean up parts of the
fsl_usb2_udc USB gadget driver. I've split them up quite finely for ease
of reviewing and to separate functional changes.

I'm testing this driver with a non-Freescale SoC containing the same
TDI/ARC/ChipIdea IP block, but the series has been tested and acked by
the maintainer.

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

