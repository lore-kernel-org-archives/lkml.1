Return-Path: <linux-kernel-owner+w=401wt.eu-S1752692AbYKRJD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbYKRJD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 04:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbYKRJDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 04:03:44 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:50304 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbYKRJDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 04:03:43 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62693721"
From: Bryan Wu <cooloney@kernel.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Blackfin SMP like patchset
Date: Tue, 18 Nov 2008 17:05:03 +0800
Message-Id: <1226999108-13839-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi folks,

We provide the SMP like functions for our Blackfin dual core processor
BF561 for almost 1 year. And after a long time developing, debugging and
internal review, we'd like to post them to LKML for other maintainer 
review.

Please find our wiki page about this SMP like patches:
http://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:smp-like

In this patchset, we split the big patch into 5 parts:

1. SMP code related to BF561 processor and machine
2. SMP for Blackfin header file and machine common code
3. SMP for Blackfin CPLB code
4. SMP for Blackfin kernel and memory management code
5. other Blackfin misc code related to SMP

Please kindly review. We are queueing these patches for 2.6.29 merge
window

Thanks
-Bryan
