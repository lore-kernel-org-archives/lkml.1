Return-Path: <linux-kernel-owner+w=401wt.eu-S1752077AbYCBGVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbYCBGVa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 01:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbYCBGUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 01:20:20 -0500
Received: from mo11.iij4u.or.jp ([210.138.174.79]:36798 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbYCBGUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 01:20:15 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-parisc@vger.kernel.org, tomof@acm.org,
       Kyle McMartin <kyle@parisc-linux.org>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 0/3] fix iommu segment boundary problems (parisc)
Date: Sun,  2 Mar 2008 15:10:25 +0900
Message-Id: <1204438228-4564-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.3.7
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is another sequel to my patchset to fix iommu segment
boundary problems, IOMMUs allocate memory areas without considering a
low level driver's segment boundary limits:

http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg11919.html

This patchset fixes the PARISC IOMMU code (sbc and ccio).

There are three patches in this patchset. The first patch is for the
IOMMU helper (lib/iommu-helper.c) to enable PARISC IOMMUs use it.

The second and third patches are for PARISC IOMMUs, the second one is
preparation for the third patch, which fixes the IOMMU segment
boundary problem.

The third patch assumes that ioc->ibase is on IOVP_SIZE boundary. If
not, please let me know. I'll fix the patch.


