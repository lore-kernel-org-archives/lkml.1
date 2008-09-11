Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbYIKCav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbYIKCav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 22:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYIKCa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 22:30:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:55633 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbYIKCa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 22:30:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,375,1217833200"; 
   d="scan'208";a="44742312"
From: Sheng Yang <sheng.yang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 0/2] Clean up for MSR_IA32_FEATURE_CONTROL
Date: Thu, 11 Sep 2008 10:33:50 +0800
Message-Id: <1221100432-9511-1-git-send-email-sheng.yang@intel.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo

Here is some follow up clean up for "Move VMX MSRs to msr-index.h". After
discussion with Avi, I found it's more proper to move MSR_IA32_FEATURE_CONTROL
bits to msr-index.h as well.

But I got a little puzzle about where to accept these patches. I suppose these
can be picked up by tip then go with kvm when it merge upstream? The main
problem is macro name changed to keep consistent style.

Thanks!
--
regards
Yang, Sheng
