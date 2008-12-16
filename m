Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbYLPE1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbYLPE1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 23:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbYLPE0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 23:26:49 -0500
Received: from relay2.sgi.com ([192.48.179.30]:53296 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751947AbYLPE0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 23:26:47 -0500
Message-Id: <20081216042645.629941000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Dec 2008 20:26:45 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] x86/cpumask: fixups and additions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patches are included:

  * x86: fix cpu_mask_to_apicid_and to include cpu_online_mask.
	Fixes potential problem when destination apicid of an
	offline cpu is returned.

  * x86: use possible_cpus=NUM to extend the number of possible cpus.
	This conforms with the existing s390 argument.

  * cpumask: add sysfs displays for configured and disabled cpu maps
	Display both the configured kernel_max cpus (NR_CPUS-1) as well
	as the cpus in the system that are disabled because they exceed
	the NR_CPUS limit.

Based on tip/cpus4096 + .../rusty/linux-2.6-for-ingo.git/master +
	 x86-only-patches sent 12/15.

Signed-off-by: Mike Travis <travis@sgi.com>

-- 
