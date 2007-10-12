Return-Path: <linux-kernel-owner+w=401wt.eu-S934161AbXJLXOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934161AbXJLXOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 19:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761472AbXJLWyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:54:41 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43513 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761565AbXJLWyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:54:38 -0400
Message-Id: <20071012225433.928899000@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 12 Oct 2007 15:54:33 -0700
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH 0/1] x86: convert-cpuinfo_x86-array-to-a-per_cpu-array fix
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This fix corrects the problem that early_identify_cpu() sets
cpu_index to '0' (needed when called by setup_arch) after
smp_store_cpu_info() had set it to the correct value.

Thanks to Suresh for discovering this problem.

-- 
