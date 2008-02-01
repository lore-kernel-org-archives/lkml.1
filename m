Return-Path: <linux-kernel-owner+w=401wt.eu-S1758704AbYBAUQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbYBAUQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 15:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYBAUQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 15:16:17 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:49040 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbYBAUQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 15:16:17 -0500
X-Greylist: delayed 847 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2008 15:16:16 EST
Date: Fri, 1 Feb 2008 21:16:15 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove old definition of setup_per_cpu_areas
Message-ID: <20080201201615.GA29187@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove old definition of setup_per_cpu_areas.

The definition is done depending on the new config variable
HAVE_SETUP_PER_CPU_AREA. 

Signed-off-by: Bastian Blank <waldi@debian.org>

diff --git a/include/asm-powerpc/percpu.h b/include/asm-powerpc/percpu.h
index cc1cbf6..f309d34 100644
--- a/include/asm-powerpc/percpu.h
+++ b/include/asm-powerpc/percpu.h
@@ -30,8 +30,6 @@ do {								\
 		       (src), (size));				\
 } while (0)
 
-extern void setup_per_cpu_areas(void);
-
 #else /* ! SMP */
 
 #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
