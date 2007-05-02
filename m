Return-Path: <linux-kernel-owner+w=401wt.eu-S1766825AbXEBRLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766825AbXEBRLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766826AbXEBRLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:11:50 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:50748 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766825AbXEBRLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:11:49 -0400
From: Kevin Corry <kevcorry@us.ibm.com>
Organization: IBM
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] powerpc: change topology_init() to a subsys_initcall
Date: Wed, 2 May 2007 12:11:49 -0500
User-Agent: KMail/1.9.5
Cc: Carl Love <carll@us.ibm.com>, Stephane Eranian <eranian@hpl.hp.com>
References: <200705021208.59068.kevcorry@us.ibm.com>
In-Reply-To: <200705021208.59068.kevcorry@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705021211.49331.kevcorry@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change the powerpc version of topology_init() from an __initcall to
a subsys_initcall to match all other architectures.

Signed-off-by: Kevin Corry <kevcorry@us.ibm.com>

Index: linux-2.6.21/arch/powerpc/kernel/sysfs.c
===================================================================
--- linux-2.6.21.orig/arch/powerpc/kernel/sysfs.c
+++ linux-2.6.21/arch/powerpc/kernel/sysfs.c
@@ -498,4 +498,4 @@ static int __init topology_init(void)
 
 	return 0;
 }
-__initcall(topology_init);
+subsys_initcall(topology_init);
