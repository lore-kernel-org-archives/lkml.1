Return-Path: <linux-kernel-owner+w=401wt.eu-S935253AbYBAHkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935253AbYBAHkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933861AbYBAHhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:37:52 -0500
Received: from rex.snapgear.com ([203.143.235.140]:48018 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933485AbYBAHhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:37:51 -0500
Date: Fri, 1 Feb 2008 17:37:08 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010737.m117b8EL022685@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU 00/06]: move common ColdFire code to its own directory
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move common ColdFire CPU code into its own platform directory.

Currently the common ColdFire CPU family code sits in the
arch/m68knommu/platform/5307 directory. This is confusing, the files
containing this common code are in no way specific to the 5307 ColdFire.
Create an arch/m68knommu/platform/coldfire directory to contain this
common code. Other m68knommu CPU varients do not need use this code
though, so it doesn't make sense to move it to arch/m68knommu/kernel.

Signed-off-by: Greg Ungerer <gerg@uclinux.org


 Makefile                    |   22 ++--
 platform/5307/Makefile      |   14 --
 platform/5307/entry.S       |  235 -------------------------------------------- platform/5307/head.S        |  222 -----------------------------------------
 platform/5307/pit.c         |   97 ------------------
 platform/5307/timers.c      |  155 -----------------------------
 platform/5307/vectors.c     |  105 -------------------
 platform/coldfire/Makefile  |   32 +++++
 platform/coldfire/dma.c     |   39 +++++++
 platform/coldfire/entry.S   |  235 ++++++++++++++++++++++++++++++++++++++++++++ platform/coldfire/head.S    |  222 +++++++++++++++++++++++++++++++++++++++++
 platform/coldfire/pit.c     |   97 ++++++++++++++++++
 platform/coldfire/timers.c  |  155 +++++++++++++++++++++++++++++
 platform/coldfire/vectors.c |  105 +++++++++++++++++++
 14 files changed, 897 insertions(+), 838 deletions(-)

