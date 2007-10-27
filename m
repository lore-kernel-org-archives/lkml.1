Return-Path: <linux-kernel-owner+w=401wt.eu-S1752887AbXJ0NHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbXJ0NHX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 09:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbXJ0NHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 09:07:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbXJ0NHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 09:07:08 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, rusty@rustcorp.com.au, zach@vmware.com, jeremy@goop.org,
       chrisw@sous-sol.org, akpm@linux-foundation.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH] select PARAVIRT when PARAVIRT_GUEST on
Date: Sat, 27 Oct 2007 11:07:12 -0300
Message-Id: <11934940321103-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d3d1c4bdf16bd154d9f27f34fca28edca90465eb introduces a new config knob
that, according to its changelog, should select CONFIG_PARAVIRT.

However, this is not being done atm.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/i386/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index b4437ce..72f6351 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -237,6 +237,7 @@ config PARAVIRT
 
 menuconfig PARAVIRT_GUEST
 	bool "Paravirtualized guest support"
+	select PARAVIRT
 	help
 	  Say Y here to get to see options related to running Linux under
 	  various hypervisors.  This option alone does not add any kernel code.
-- 
1.5.0.6

