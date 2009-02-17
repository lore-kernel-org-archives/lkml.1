Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbZBQQ4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbZBQQ4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 11:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbZBQQ4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 11:56:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35638 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbZBQQ4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 11:56:30 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/3] MN10300: Fix oprofile
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Tue, 17 Feb 2009 16:55:58 +0000
Message-ID: <20090217165558.17657.40009.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090217165552.17657.90940.stgit@warthog.procyon.org.uk>
References: <20090217165552.17657.90940.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oprofile for MN10300 seems to have been broken by the advent of the new tracing
framework.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 9a9f433..41d1682 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -7,6 +7,7 @@ mainmenu "Linux Kernel Configuration"
 
 config MN10300
 	def_bool y
+	select HAVE_OPROFILE
 
 config AM33
 	def_bool y

