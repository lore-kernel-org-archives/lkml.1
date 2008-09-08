Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbYIHKkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbYIHKkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 06:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbYIHKjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 06:39:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:17249 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbYIHKjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 06:39:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,357,1217833200"; 
   d="scan'208";a="333924720"
From: Sheng Yang <sheng.yang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org,
       Sheng Yang <sheng.yang@intel.com>
Subject: [RFC][PATCH 0/2] x86: Add "virt flags"
Date: Mon,  8 Sep 2008 18:42:33 +0800
Message-Id: <12208705553277-git-send-email-sheng.yang@intel.com>
X-Mailer: git-send-email 1.5.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo

(sorry for former noises, I mistake the address... Report to lkml)
I've sent this patchset before, but got no comments from upstream at that
time.  So I'd like to resend this.

The virt flags is used for the important hardware virtualization features,
like EPT of incoming Nehalem. Because the feature availability are read from
MSRs, and I think virtualization features should not at the same level as
"vmx", so I added a new flags catagory here.

But I still have concern, for this may broke some not that reliable userspace
programs. So Avi suggested that we can add more fields to flags rather than a
new catagory.  What's your opinion? We indeed need a generic user visible way
to tell the HW virtualization features.

Thanks!
--
regards
Yang, Sheng
