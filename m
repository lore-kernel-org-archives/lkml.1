Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbZJRRYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbZJRRYF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 13:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbZJRRYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 13:24:01 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:46712 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754692AbZJRRX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 13:23:59 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v4 5/7] m68knommu: Move __init_begin out of the .init section.
Date: Sun, 18 Oct 2009 13:23:53 -0400
Message-Id: <1255886635-17371-5-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <alpine.DEB.1.10.0910142041520.6638@dr-wily.mit.edu>
References: <alpine.DEB.1.10.0910142041520.6638@dr-wily.mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 arch/m68knommu/kernel/vmlinux.lds.S |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
index ac7e785..0d430da 100644
--- a/arch/m68knommu/kernel/vmlinux.lds.S
+++ b/arch/m68knommu/kernel/vmlinux.lds.S
@@ -157,6 +157,8 @@ SECTIONS {
 	.init : {
 		. = ALIGN(PAGE_SIZE);
 		__init_begin = .;
+	} > INIT
+	.init : {
 		_sinittext = .;
 		INIT_TEXT
 		_einittext = .;
-- 
1.6.4.3

