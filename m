Return-Path: <linux-kernel-owner+w=401wt.eu-S1751664AbZGTO0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbZGTO0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 10:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZGTO0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 10:26:15 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:49019 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbZGTO0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 10:26:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vG0VdL8PU4z3kK7lIGFunp2bZh/bj+xp5vC1S/oSqvbG+mWX1Swbn93gHipgDdm0Hl
         BoFJXlysGi4k/UF8/Oz60HJYnh8UL9+dRfwymnaOLGy2Xh6V4aKMumL95USuU5okRZeC
         XwntWpMiBaGYfWu528cQuYfL/TpNOwT4aSr2E=
From: tom.leiming@gmail.com
To: linux@arm.linux.org.uk, rmk@arm.linux.org.uk
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v2 0/4] ARM:dma-mapping:DMA-API debugging patch set
Date: Mon, 20 Jul 2009 22:25:50 +0800
Message-Id: <1248099954-6666-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

Hi,
This patch set introduces dma-api debugging facility on ARM, and is
against -rc3-next tree.

Based on the feedback from Russell King, this version removes
unnecessary calling of debug_dma_map_page and debug_dma_unmap_page
in dma_map_sg and dma_unmap_sg respectively.

 arch/arm/Kconfig                   |    1 +
 arch/arm/common/dmabounce.c        |   12 ++--
 arch/arm/include/asm/dma-mapping.h |  114 +++++++++++++++++++++++++++++-------
 arch/arm/mm/dma-mapping.c          |   41 ++++++++-----
 4 files changed, 126 insertions(+), 42 deletions(-)

Thanks.
