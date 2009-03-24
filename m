Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZCXVof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZCXVof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbZCXVoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:44:25 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:34827 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbZCXVoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:44:24 -0400
From: Becky Bruce <beckyb@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com,
       jeremy@goop.org
Subject: [PATCH 0/5] swiotlb: changes for powerpc/highmem
Date: Tue, 24 Mar 2009 16:28:41 -0500
Message-Id: <1237930126-6741-1-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a series of fairly minor patches that get swiotlb working
on 32-bit powerpc systems with HIGHMEM, plus some cleanup of the
outdated comments in the code.  I've made a couple of things
weak that ppc needs to override, and have changed the prototypes
for a couple of functions to include the hwdev pointer, which
we need to ppc to convert bus addresses to and from phys/virt
addresses.  I've also fixed a build warning I've been seeing on
ppc.

I have not tested this in any way on any non-ppc platforms,
so commentary/testing from x86/ia64 folks is greatly 
appreciated.

diffstat:
 arch/x86/kernel/pci-swiotlb.c |    2 +-
 include/linux/swiotlb.h       |    4 ++-
 lib/swiotlb.c                 |   70 +++++++++++++++++++++++-----------------
 3 files changed, 44 insertions(+), 32 deletions(-)

Cheers,
Becky


