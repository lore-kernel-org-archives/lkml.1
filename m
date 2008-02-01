Return-Path: <linux-kernel-owner+w=401wt.eu-S934291AbYBAHsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934291AbYBAHsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935288AbYBAHk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:40:59 -0500
Received: from rex.snapgear.com ([203.143.235.140]:48099 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933641AbYBAHk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:40:58 -0500
Date: Fri, 1 Feb 2008 17:40:12 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010740.m117eCOn022772@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU 00/07]: switch to GENERIC_TIME
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch the m68knommu arch to using CONFIG_GENERIC_TIME.

There is a number of different timers on the vairous m68knommu
family members, so there is a few files affected.

Signed-off-by: Greg Ungerer <gerg@uclinux.org

 linux-2.6.24/arch/m68knommu/Kconfig                    |    4
 linux-2.6.24/arch/m68knommu/kernel/time.c              |   57 ---------
 linux-2.6.24/arch/m68knommu/platform/68328/timers.c    |   56 +++++++--
 linux-2.6.24/arch/m68knommu/platform/68360/config.c    |    5
 linux-2.6.24/arch/m68knommu/platform/5206/config.c     |   14 --
 linux-2.6.24/arch/m68knommu/platform/5206e/config.c    |   14 --
 linux-2.6.24/arch/m68knommu/platform/5249/config.c     |   14 --
 linux-2.6.24/arch/m68knommu/platform/5272/config.c     |   13 --
 linux-2.6.24/arch/m68knommu/platform/5307/config.c     |   14 --
 linux-2.6.24/arch/m68knommu/platform/532x/config.c     |   14 --
 linux-2.6.24/arch/m68knommu/platform/5407/config.c     |   14 --
 linux-2.6.24/arch/m68knommu/platform/coldfire/pit.c    |   86 ++++++++-------
 linux-2.6.24/arch/m68knommu/platform/coldfire/timers.c |   68 +++++++----
 13 files changed, 142 insertions(+), 231 deletions(-)

