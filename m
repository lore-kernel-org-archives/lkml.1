Return-Path: <linux-kernel-owner+w=401wt.eu-S1759921AbZEANsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921AbZEANsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756436AbZEANru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:47:50 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:59103 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbZEANrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:47:49 -0400
Date: Fri, 1 May 2009 14:45:43 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: mel@csn.ul.ie, andi@firstfloor.org, davem@davemloft.net, anton@samba.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH 2.6.30] Doc: hashdist defaults on for 64bit
In-Reply-To: <Pine.LNX.4.64.0905011354560.19012@blonde.anvils>
Message-ID: <Pine.LNX.4.64.0905011442540.19247@blonde.anvils>
References: <Pine.LNX.4.64.0904292151350.30874@blonde.anvils>
 <20090429142825.6dcf233d.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0905011354560.19012@blonde.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update Doc: kernel boot parameter hashdist now defaults on for all 64bit NUMA.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 Documentation/kernel-parameters.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.30-rc4/Documentation/kernel-parameters.txt	2009-04-30 06:39:30.000000000 +0100
+++ linux/Documentation/kernel-parameters.txt	2009-05-01 14:08:56.000000000 +0100
@@ -775,7 +775,7 @@ and is between 256 and 4096 characters.
 
 	hashdist=	[KNL,NUMA] Large hashes allocated during boot
 			are distributed across NUMA nodes.  Defaults on
-			for IA-64, off otherwise.
+			for 64bit NUMA, off otherwise.
 			Format: 0 | 1 (for off | on)
 
 	hcl=		[IA-64] SGI's Hardware Graph compatibility layer
