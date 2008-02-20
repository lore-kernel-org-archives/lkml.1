Return-Path: <linux-kernel-owner+w=401wt.eu-S1764887AbYBTTpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764887AbYBTTpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 14:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbYBTTpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 14:45:16 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:60498 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756863AbYBTTpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 14:45:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=mZTdFn3oHI/LUn/8ll1FcyybuOIELTkRzPIOMqfv0Ew/8f/Vlpbha3mytru0n0FPf/2UKK84EOLLqbDoNdAPUXmhSRCarDwxSxUSyqaT1Pf9onG4f1vaWkPEXzj7Lk88lSWRCzzoBvWaqo8EHBkunNRJUoxzCJEMWXQy2VP4Hu0=
Message-Id: <20080220194444.348896940@gmail.com>
References: <20080220194123.114692303@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Feb 2008 22:41:26 +0300
From: gorcunov@gmail.com
To: takata@linux-m32r.org, dhowells@redhat.com, schwidefsky@de.ibm.com
Cc: sam@ravnborg.org, gorcunov@gmail.com, linux-kernel@vger.kernel.org
Subject: [patch 3/3] s390: cleanup - drop .data.idt section in vmlinux.lds script
Content-Disposition: inline; filename=s390-idt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The section .data.idt is not used at all - so drop it.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 vmlinux.lds.S |    5 -----
 1 file changed, 5 deletions(-)

Index: linux-2.6.git/arch/s390/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.git.orig/arch/s390/kernel/vmlinux.lds.S	2008-02-06 23:15:14.000000000 +0300
+++ linux-2.6.git/arch/s390/kernel/vmlinux.lds.S	2008-02-20 22:30:30.000000000 +0300
@@ -71,11 +71,6 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	__nosave_end = .;
 
-	. = ALIGN(PAGE_SIZE);
-	.data.page_aligned : {
-		*(.data.idt)
-	}
-
 	. = ALIGN(0x100);
 	.data.cacheline_aligned : {
 		*(.data.cacheline_aligned)

-- 
