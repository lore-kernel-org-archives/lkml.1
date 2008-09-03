Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbYICSPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbYICSPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbYICSPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:15:00 -0400
Received: from mfo11.iij4u.or.jp ([210.138.174.81]:36079 "EHLO
	mfo11.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbYICSO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:14:59 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: joerg.roedel@amd.com, mingo@redhat.com, tony.luck@intel.com,
       kamezawa.hiroyu@jp.fujitsu.com, iommu@lists.linux-foundation.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 0/3] fix swiotlb allocation gfp flag
Date: Thu,  4 Sep 2008 03:04:22 +0900
Message-Id: <1220465065-10533-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1220454224-25985-1-git-send-email-joerg.roedel@amd.com>
References: <1220454224-25985-1-git-send-email-joerg.roedel@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes a problem (in the x86 tree) that swiotlb always
use GFP_DMA so we exhaust ZONE_DMA.

This is against tip/master.


