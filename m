Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbYC0XRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbYC0XRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 19:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYC0XQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 19:16:55 -0400
Received: from relay1.sgi.com ([192.48.171.29]:43855 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751986AbYC0XQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 19:16:55 -0400
Message-Id: <20080327231654.284673000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Mar 2008 16:16:54 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] x86: add functions in preparation of cpumask changes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some more small changes for x86 in preparation of larger cpumask changes.

    * Introduce the cpumask_of_cpu_map via Kconfig option

    * Modify show_shared_cpu_map in intel_cacheinfo.c to use
      cpulist_scnprintf() instead of cpumask_scnprintf().  This
      eliminates the need for the new function cpumask_scnprintf_len().

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

Signed-off-by: Mike Travis <travis@sgi.com>

-- 
