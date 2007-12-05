Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbXLETsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbXLETsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 14:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbXLETlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 14:41:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689AbXLETk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 14:40:29 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 13/28] CacheFiles: Add missing copy_page export for ia64 [try
	#2]
To: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 05 Dec 2007 19:39:24 +0000
Message-ID: <20071205193924.24617.75532.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
References: <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one-line patch fixes the missing export of copy_page introduced
by the cachefile patches.  This patch is not yet upstream, but is required
for cachefile on ia64.  It will be pushed upstream when cachefile goes
upstream.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/ia64/kernel/ia64_ksyms.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kernel/ia64_ksyms.c b/arch/ia64/kernel/ia64_ksyms.c
index bd17190..20c3546 100644
--- a/arch/ia64/kernel/ia64_ksyms.c
+++ b/arch/ia64/kernel/ia64_ksyms.c
@@ -43,6 +43,7 @@ EXPORT_SYMBOL(__do_clear_user);
 EXPORT_SYMBOL(__strlen_user);
 EXPORT_SYMBOL(__strncpy_from_user);
 EXPORT_SYMBOL(__strnlen_user);
+EXPORT_SYMBOL(copy_page);
 
 /* from arch/ia64/lib */
 extern void __divsi3(void);

