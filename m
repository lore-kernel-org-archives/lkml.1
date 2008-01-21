Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbYAUU2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbYAUU2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 15:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYAUU1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 15:27:54 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55914 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751046AbYAUU1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 15:27:53 -0500
Message-Id: <20080121202748.047065000@sgi.com>
References: <20080121202747.593568000@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 21 Jan 2008 12:27:50 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] pecpu: Fix size of percpu_data.ptrs array rc8-mm1-fixup
Content-Disposition: inline; filename=generic-percpu-fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the size of the generic percpu pointers array to be NR_CPUS

Based on: 2.6.24-rc8-mm1

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>

---
 include/linux/percpu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -58,7 +58,7 @@
 #ifdef CONFIG_SMP
 
 struct percpu_data {
-	void *ptrs[1];
+	void *ptrs[NR_CPUS];
 };
 
 #define __percpu_disguise(pdata) (struct percpu_data *)~(unsigned long)(pdata)

-- 
