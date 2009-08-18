Return-Path: <linux-kernel-owner+w=401wt.eu-S932530AbZHRRrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530AbZHRRrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 13:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759383AbZHRRrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 13:47:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32852 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759342AbZHRRrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 13:47:39 -0400
Date: Tue, 18 Aug 2009 13:47:37 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>
Subject: Make LSM_MMAP_MIN_ADDR default match its help text.
Message-ID: <20090818174736.GA23352@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>
References: <200908172100.n7HL08SR001061@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908172100.n7HL08SR001061@hera.kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 788084aba2ab7348257597496befcbccabdc98a3 added the LSM_MMAP_MIN_ADDR
option, whose help text states "For most ia64, ppc64 and x86 users with lots
of address space a value of 65536 is reasonable and should cause no problems."
Which implies that it's default setting was typoed.

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6.30.noarch/security/Kconfig~	2009-08-18 13:45:33.000000000 -0400
+++ linux-2.6.30.noarch/security/Kconfig	2009-08-18 13:45:36.000000000 -0400
@@ -116,7 +116,7 @@ config SECURITY_ROOTPLUG
 config LSM_MMAP_MIN_ADDR
 	int "Low address space for LSM to from user allocation"
 	depends on SECURITY && SECURITY_SELINUX
-	default 65535
+	default 65536
 	help
 	  This is the portion of low virtual memory which should be protected
 	  from userspace allocation.  Keeping a user from writing to low pages
