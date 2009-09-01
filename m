Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbZIAIvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbZIAIvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZIAIvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:51:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48622 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbZIAIvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:51:42 -0400
Message-Id: <20090901083431.748830771@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 01 Sep 2009 10:34:31 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 0/8] load-balancing and cpu_power -v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A more complete version, one that compiles and mostly works on the
simple tests to which it was subjected.

It still lacks integration with APERF/MPERF because that stuff was
hidding in some acpi driver instead of placed in arch code for general
consumption.. will fix.

Also, SD_SHARE_CPUPOWER seems redundant in the face of sd->level ==
SD_LV_SIBLING, should we remove the SD_flag or depricate the level?

Anyway, have at it, poke holes and report issues.

