Return-Path: <linux-kernel-owner+w=401wt.eu-S1753116AbXCMEoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbXCMEoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 00:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbXCMEoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 00:44:34 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36713 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbXCMEod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 00:44:33 -0400
Date: Mon, 12 Mar 2007 21:43:29 -0700
From: sukadev@us.ibm.com
To: Andrew Morton <akpm@osdl.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Eric Biederman <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] Explicitly set pgid and sid of init process
Message-ID: <20070313044329.GB8884@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: [PATCH 2/5] Explicitly set pgid and sid of init process

Explicitly set pgid and sid of init process to 1.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: <containers@lists.osdl.org>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
---

 init/main.c |    1 +
 1 file changed, 1 insertion(+)

Index: lx26-20-mm2c/init/main.c
===================================================================
--- lx26-20-mm2c.orig/init/main.c	2007-02-28 15:49:13.000000000 -0800
+++ lx26-20-mm2c/init/main.c	2007-02-28 15:49:35.000000000 -0800
@@ -791,6 +791,7 @@ static int __init init(void * unused)
 	 */
 	init_pid_ns.child_reaper = current;
 
+	__set_special_pids(1, 1);
 	cad_pid = task_pid(current);
 
 	smp_prepare_cpus(max_cpus);
