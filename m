Return-Path: <linux-kernel-owner+w=401wt.eu-S1762378AbXGYOHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762378AbXGYOHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 10:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbXGYOHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 10:07:06 -0400
Received: from rex.snapgear.com ([203.143.235.140]:59455 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754247AbXGYOHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 10:07:04 -0400
Date: Thu, 26 Jul 2007 00:06:25 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707251406.l6PE6Poj005817@goober>
To: linux-kernel@vger.kernel.org
Subject: [M68KNOMMU 00/06]: cleanup m68knommu timers
Cc: gerg@uclinux.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following patches are a first pass at cleaning up the m68knommu
timers. The main purpose of this set is to remove the early use
of request_irq() and to remove the external references to the timer
functions all over the board/cpu setup code.

 linux/arch/m68knommu/kernel/time.c                  |   22 ++----
 linux/arch/m68knommu/platform/5307/pit.c            |   22 ++++--
 linux/arch/m68knommu/platform/5307/timers.c         |   26 +++++---
 linux/arch/m68knommu/platform/68328/timers.c        |   32 ++++++----
 linux/arch/m68knommu/platform/68360/config.c        |   51 ++++++----------
 linux/arch/m68knommu/platform/5206/config.c         |   13 ----
 linux/arch/m68knommu/platform/5206e/config.c        |   15 ----
 linux/arch/m68knommu/platform/520x/config.c         |   10 ---
 linux/arch/m68knommu/platform/523x/config.c         |   12 ---
 linux/arch/m68knommu/platform/5249/config.c         |   13 ----
 linux/arch/m68knommu/platform/5272/config.c         |   13 ----
 linux/arch/m68knommu/platform/527x/config.c         |   12 ---
 linux/arch/m68knommu/platform/528x/config.c         |   12 ---
 linux/arch/m68knommu/platform/5307/config.c         |   13 ----
 linux/arch/m68knommu/platform/532x/config.c         |   13 ----
 linux/arch/m68knommu/platform/5407/config.c         |   13 ----
 linux/arch/m68knommu/platform/68328/config.c        |   19 -----
 linux/arch/m68knommu/platform/68360/config.c        |    4 -
 linux/arch/m68knommu/platform/68EZ328/config.c      |    8 --
 linux/arch/m68knommu/platform/68VZ328/config.c      |    6 -
 20 files changed, 93 insertions(+), 236 deletions(-)

