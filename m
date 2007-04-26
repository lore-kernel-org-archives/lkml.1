Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbXDZGKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbXDZGKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768AbXDZGKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:10:53 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:33982 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbXDZGKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:10:52 -0400
Date: Thu, 26 Apr 2007 02:10:50 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH 10/12] selinux: remove unused enumeration constant from
 selinuxfs
In-Reply-To: <Line.LNX.4.64.0704260200450.30059@d.namei>
Message-ID: <Line.LNX.4.64.0704260210220.30059@d.namei>
References: <Line.LNX.4.64.0704260200450.30059@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Carter <jwcart2@tycho.nsa.gov>

Remove the unused enumeration constant, SEL_AVC, from the sel_inos
enumeration in selinuxfs.

Signed-off-by: James Carter <jwcart2@tycho.nsa.gov>
Acked-by: Eric Paris <eparis@parisplace.org>
Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/selinuxfs.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 1a786db..097bc04 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -96,7 +96,6 @@ enum sel_inos {
 	SEL_COMMIT_BOOLS, /* commit new boolean values */
 	SEL_MLS,	/* return if MLS policy is enabled */
 	SEL_DISABLE,	/* disable SELinux until next reboot */
-	SEL_AVC,	/* AVC management directory */
 	SEL_MEMBER,	/* compute polyinstantiation membership decision */
 	SEL_CHECKREQPROT, /* check requested protection, not kernel-applied one */
 	SEL_COMPAT_NET,	/* whether to use old compat network packet controls */
-- 
1.5.0.6

