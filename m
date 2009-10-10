Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbZJJWuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbZJJWuy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 18:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbZJJWux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 18:50:53 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:33720 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932107AbZJJWuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 18:50:51 -0400
Subject: Ignore files nclude/generated/kernel.{arch,cross}
Message-Id: <20091010225011.905569273@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben@simtec.co.uk>
To: linux-kernel@vger.kernel.org
Content-Disposition: inline; filename=ignore-autogen.patch
Date: Sat, 10 Oct 2009 23:50:12 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The files nclude/generated/kernel.arch and nclude/generated/kernel.cross
should not be appearing in diffs, so add them to Documentation/dontdiff

Signed-off-by: Ben Dooks <ben@simtec.co.uk>

---
 Documentation/dontdiff |    2 ++
 1 file changed, 2 insertions(+)

Index: b/Documentation/dontdiff
===================================================================
--- a/Documentation/dontdiff	2009-10-10 23:42:44.000000000 +0100
+++ b/Documentation/dontdiff	2009-10-10 23:43:32.000000000 +0100
@@ -110,6 +110,8 @@ initramfs_data.cpio.gz
 initramfs_list
 kallsyms
 kconfig
+kernel.arch
+kernel.cross
 keywords.c
 ksym.c*
 ksym.h*

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
