Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbYBWGQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbYBWGQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 01:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbYBWGPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 01:15:50 -0500
Received: from mo11.iij4u.or.jp ([210.138.174.79]:55463 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbYBWGPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 01:15:49 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: tomof@acm.org, Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 0/4] fix iommu segment boundary problems (alpha)
Date: Sat, 23 Feb 2008 15:13:11 +0900
Message-Id: <1203747195-7952-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.3.7
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset is another sequel to my patchset to fix iommu segment
boundary problems, IOMMUs allocate memory areas without considering a
low level driver's segment boundary limits:

http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg11919.html

This patchset fixes the Alpha IOMMU code.

There are four patches in this patchset. The first two patches are
preparation for the third patch, which fixes the IOMMU segment
boundary problem. The fourth patch just a cleanup, which removes an
unused code.

This is against 2.6.25-rc2-mm1.

