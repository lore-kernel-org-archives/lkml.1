Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbZEVXZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbZEVXZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 19:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757970AbZEVXZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 19:25:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:49197 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757944AbZEVXZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 19:25:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,235,1241420400"; 
   d="scan'208";a="146035748"
Message-Id: <20090522231940.553094000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 22 May 2009 16:19:40 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, shaohua.li@intel.com,
       svaidy@linux.vnet.ibm.com, a.p.zijlstra@chello.nl,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 0/2] x86: Make offline cpus to go to deepest idle state using mwait
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu hotplug has this long standing bug, with offline cpus going into
hlt loop. That can result in offline CPU burning more power than while it is
in online state (as when online it can potentially go to deeper C-state).
Fix the bug using native mwait to enter deepest C-state in play_dead.

-- 

