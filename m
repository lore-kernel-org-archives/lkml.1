Return-Path: <linux-kernel-owner+w=401wt.eu-S1762318AbXJDWbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762318AbXJDWbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 18:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761182AbXJDWbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 18:31:43 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35759 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760451AbXJDWbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 18:31:42 -0400
Message-Id: <20071004223141.413776000@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Oct 2007 15:31:41 -0700
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Tony Luck <tony.luck@intel.com>, Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
Subject: [PATCH 0/1] ia64: Convert cpu_sibling_map to a per_cpu data array FIX
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The previous version of this patch missed a code path in
inserting the boot cpu into the cpu sibling and core maps.

This fix corrects that omission.
--

-- 
