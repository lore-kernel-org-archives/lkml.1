Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab0CCQQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:16:58 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:62406 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab0CCQQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:16:56 -0500
Date: Wed, 03 Mar 2010 10:16:44 -0600
From: Corey Minyard <minyard@acm.org>
To: torvalds@linux-foundation.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: [PATCH 3/4] IPMI: Remove ipmi_smi.h self-include
Message-id: <20100303161644.GC17623@minyard.local>
Reply-to: minyard@acm.org
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <minyard@acm.org>

There is no need for linux/ipmi_smi.h to include itself.

Signed-off-by: Corey Minyard <minyard@acm.org>

Index: linux-2.6.29/include/linux/ipmi_smi.h
===================================================================
--- linux-2.6.29.orig/include/linux/ipmi_smi.h
+++ linux-2.6.29/include/linux/ipmi_smi.h
@@ -39,7 +39,6 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
-#include <linux/ipmi_smi.h>
 
 /* This files describes the interface for IPMI system management interface
    drivers to bind into the IPMI message handler. */
