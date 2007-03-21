Return-Path: <linux-kernel-owner+w=401wt.eu-S1752914AbXCUPLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbXCUPLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbXCUPLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:11:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47088 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbXCUPLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:11:20 -0400
Date: Wed, 21 Mar 2007 11:11:14 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20070321151114.31684.54996.sendpatchset@prarit.boston.redhat.com>
Subject: [PATCH]: Resubmitting: Add __init to probe_bigsmp
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Originally submitted Feb 13, 2007.

Add __init to probe_bigsmp.  All callers are __init and data being examined
is __initdata.

Resolves BZ 228543.

Successfully tested by me.

--- linux-2.6.18.i386.orig/arch/i386/mach-generic/bigsmp.c	2007-02-05 13:29:12.000000000 -0500
+++ linux-2.6.18.i386/arch/i386/mach-generic/bigsmp.c	2007-02-13 13:15:06.000000000 -0500
@@ -44,7 +44,7 @@ static struct dmi_system_id __initdata b
 };
 
 
-static int probe_bigsmp(void)
+static int __init probe_bigsmp(void)
 { 
 	if (def_to_bigsmp)
         	dmi_bigsmp = 1;
