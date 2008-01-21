Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYAUVQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYAUVQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbYAUVQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:16:01 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57255 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751888AbYAUVQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:16:00 -0500
Message-Id: <20080121211600.079162000@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 21 Jan 2008 13:16:00 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] x86: Reduce memory usage for large count NR_CPUs fixup V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixup change NR_CPUS patchset by rebasing on 2.6.24-rc8-mm1
(from 2.6.24-rc6-mm1) and adding changes suggested by reviews.

Based on 2.6.24-rc8-mm1

Note there are two versions of this patchset:
	- 2.6.24-rc8-mm1
	- 2.6.24-rc8-mm1 + latest (08/1/21) git-x86

Signed-off-by: Mike Travis <travis@sgi.com>
---
Fixup-V2:
    - pulled the SMP_MAX patch as it's not strictly needed and some
      more work on local cpumask_t variables needs to be done before
      NR_CPUS is allowed to increase.

    - changes to X86_32 have been removed (except for build errors)

-- 
