Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbYHUCgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbYHUCgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 22:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbYHUCgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 22:36:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:47008 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbYHUCgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 22:36:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,243,1217833200"; 
   d="scan'208";a="430955227"
Subject: [patch 0/4]array interface pageattr APIs for AGP
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Dave Airlie <airlied@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 10:46:03 +0800
Message-Id: <1219286763.18007.38.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are Dave Airlie's array interface patches for pageattr. I
refreshed them and did bug fixing. The purpose of the patches is to
reduce tlb/cache flush in agp gart memory allocation.

the patches apply to tip tree, but please remove my two patches first
1ac2f7d55b7ee1613c90631e87fea22ec06781e5
466ae837424dcc538b1af2a0eaf53be32edcdbe7

Thanks,
Shaohua

