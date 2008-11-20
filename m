Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbYKTNNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbYKTNNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 08:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754727AbYKTNMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 08:12:53 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:10627 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbYKTNMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 08:12:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=fR3i7/GjUkL90BCEX4HGiAtp4QkqR1JK7UDDb0ZYMvOvJXcwie4zCtcCzWxIN+eQUU
         N+/FJFERwoX3bFT3UDRb1QHXVcxgrbbhp0cfVxR+1k/zL1NxY6iDvR6fjALATFi1jcqe
         Tw9sYWEbH/U+v2rO7YYeVSW5zHW6kkySaYa/4=
Message-ID: <b9df5fa10811200512x5b7e772rba7ca8900fc4bd40@mail.gmail.com>
Date: Thu, 20 Nov 2008 19:12:50 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] x86: Fixing __cpuinit/__init tangle.
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linux-2.6-orig/arch/x86/kernel/xsave.c	2008-11-17 20:30:12.000000000 +0600
+++ linux-2.6/arch/x86/kernel/xsave.c	2008-11-19 05:48:35.000000000 +0600
@@ -310,7 +310,7 @@ static void __init setup_xstate_init(voi
 /*
  * Enable and initialize the xsave feature.
  */
-void __init xsave_cntxt_init(void)
+void __ref xsave_cntxt_init(void)
 {
 	unsigned int eax, ebx, ecx, edx;
