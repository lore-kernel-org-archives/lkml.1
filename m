Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbXEBEaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbXEBEaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 00:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992735AbXEBE3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 00:29:05 -0400
Received: from smtp-out.google.com ([216.239.45.13]:24904 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992715AbXEBE24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 00:28:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=vxvtlq132IxsKpmBZEt+CMsMz2+1M6Jhcxk9ha1bJgl55laEz7KnQab/UHGlGNtBk
	WHeQDD6myvNsabpO+fEiQ==
Date: Tue, 1 May 2007 21:28:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ralf Baechle <ralf@linux-mips.org>,
       Thomas Koeller <thomas.koeller@baslerweb.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 07/10] mips: excite: use __attribute_unused__
In-Reply-To: <Pine.LNX.4.64.0705012122120.19277@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0705012122480.19277@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012119370.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012120130.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012120470.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012121350.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012122120.19277@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace variable instances of __attribute__((unused)) with
__attribute_unused__.

Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Thomas Koeller <thomas.koeller@baslerweb.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/mips/basler/excite/excite_device.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/mips/basler/excite/excite_device.c b/arch/mips/basler/excite/excite_device.c
--- a/arch/mips/basler/excite/excite_device.c
+++ b/arch/mips/basler/excite/excite_device.c
@@ -68,7 +68,7 @@ enum {
 
 
 static struct resource
-	excite_ctr_resource __attribute__((unused)) = {
+	excite_ctr_resource __attribute_unused__ = {
 		.name		= "GPI counters",
 		.start		= 0,
 		.end		= 5,
@@ -77,7 +77,7 @@ static struct resource
 		.sibling	= NULL,
 		.child		= NULL
 	},
-	excite_gpislice_resource __attribute__((unused)) = {
+	excite_gpislice_resource __attribute_unused__ = {
 		.name		= "GPI slices",
 		.start		= 0,
 		.end		= 1,
@@ -86,7 +86,7 @@ static struct resource
 		.sibling	= NULL,
 		.child		= NULL
 	},
-	excite_mdio_channel_resource __attribute__((unused)) = {
+	excite_mdio_channel_resource __attribute_unused__ = {
 		.name		= "MDIO channels",
 		.start		= 0,
 		.end		= 1,
@@ -95,7 +95,7 @@ static struct resource
 		.sibling	= NULL,
 		.child		= NULL
 	},
-	excite_fifomem_resource __attribute__((unused)) = {
+	excite_fifomem_resource __attribute_unused__ = {
 		.name		= "FIFO memory",
 		.start		= 0,
 		.end		= 767,
@@ -104,7 +104,7 @@ static struct resource
 		.sibling	= NULL,
 		.child		= NULL
 	},
-	excite_scram_resource __attribute__((unused)) = {
+	excite_scram_resource __attribute_unused__ = {
 		.name		= "Scratch RAM",
 		.start		= EXCITE_PHYS_SCRAM,
 		.end		= EXCITE_PHYS_SCRAM + EXCITE_SIZE_SCRAM - 1,
@@ -113,7 +113,7 @@ static struct resource
 		.sibling	= NULL,
 		.child		= NULL
 	},
-	excite_fpga_resource __attribute__((unused)) = {
+	excite_fpga_resource __attribute_unused__ = {
 		.name		= "System FPGA",
 		.start		= EXCITE_PHYS_FPGA,
 		.end		= EXCITE_PHYS_FPGA + EXCITE_SIZE_FPGA - 1,
@@ -122,7 +122,7 @@ static struct resource
 		.sibling	= NULL,
 		.child		= NULL
 	},
-	excite_nand_resource __attribute__((unused)) = {
+	excite_nand_resource __attribute_unused__ = {
 		.name		= "NAND flash control",
 		.start		= EXCITE_PHYS_NAND,
 		.end		= EXCITE_PHYS_NAND + EXCITE_SIZE_NAND - 1,
@@ -131,7 +131,7 @@ static struct resource
 		.sibling	= NULL,
 		.child		= NULL
 	},
-	excite_titan_resource __attribute__((unused)) = {
+	excite_titan_resource __attribute_unused__ = {
 		.name		= "TITAN registers",
 		.start		= EXCITE_PHYS_TITAN,
 		.end		= EXCITE_PHYS_TITAN + EXCITE_SIZE_TITAN - 1,
