Return-Path: <linux-kernel-owner+w=401wt.eu-S1751569Ab0AaGNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab0AaGNV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 01:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312Ab0AaGNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 01:13:20 -0500
Received: from ozlabs.org ([203.10.76.45]:34096 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab0AaGNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 01:13:20 -0500
Date: Sun, 31 Jan 2010 17:12:21 +1100
From: Anton Blanchard <anton@samba.org>
To: Akinobu Mita <akinobu.mita@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH] fault injection: Correct function names in documentation
Message-ID: <20100131061221.GK2996@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


init_fault_attr_entries should be init_fault_attr_dentries 
cleanup_fault_attr_entries should be cleanup_fault_attr_dentries

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-cpumask/Documentation/fault-injection/fault-injection.txt
===================================================================
--- linux-cpumask.orig/Documentation/fault-injection/fault-injection.txt	2010-01-30 17:20:54.147210801 +1100
+++ linux-cpumask/Documentation/fault-injection/fault-injection.txt	2010-01-31 17:11:10.737211232 +1100
@@ -143,8 +143,8 @@ o provide a way to configure fault attri
   failslab, fail_page_alloc, and fail_make_request use this way.
   Helper functions:
 
-	init_fault_attr_entries(entries, attr, name);
-	void cleanup_fault_attr_entries(entries);
+	init_fault_attr_dentries(entries, attr, name);
+	void cleanup_fault_attr_dentries(entries);
 
 - module parameters
 
