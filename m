Return-Path: <linux-kernel-owner+w=401wt.eu-S934137AbYB2WLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934137AbYB2WLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 17:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759706AbYB2WLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 17:11:42 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:62757 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761578AbYB2WLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 17:11:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jtaz9t5o0cmowLh1QZF1PFG6MMS17bhCTD9VmqHIeSrdYb/zeR1zOXBxHGJrKUcIEH+yJh6csiQitAifOa6l0y2jfeYrnIJLgR/+aD+JmT3NdvFhjxJ1DaXryTxCNjzMJsh56gGvX1u+hQE0eqDHfdMkWDhqN9ySO7XNDKEi+zA=
Message-ID: <c384c5ea0802291411s44cfb349r811da1e7daaefa19@mail.gmail.com>
Date: Fri, 29 Feb 2008 23:11:40 +0100
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix build, missing profile.h include in kernel/sysctl.c (against 2.6.24.3-rt3)
Cc: "Steven Rostedt" <rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build fix for kernel/sysctl.c:356: error: 'prof_pid' undeclared here
(not in a function).
The fix is to include <linux/profile.h> which defines prof_pid as external.
Patch is against 2.6.24.3-rt3.

Signed-off-by: Leon Woestenberg <leon@sidebranch.com>

Index: linux-2.6.24.3/kernel/sysctl.c
===================================================================
--- linux-2.6.24.3.orig/kernel/sysctl.c 2008-02-29 00:52:45.000000000 +0100
+++ linux-2.6.24.3/kernel/sysctl.c      2008-02-29 00:52:59.000000000 +0100
@@ -47,6 +47,7 @@
 #include <linux/acpi.h>
 #include <linux/reboot.h>
 #include <linux/ftrace.h>
+#include <linux/profile.h>

 #include <asm/uaccess.h>
 #include <asm/processor.h>


-- 
Leon
