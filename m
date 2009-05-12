Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbZELJnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbZELJnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbZELJmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:42:50 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:44832 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbZELJmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:42:49 -0400
X-Auth-Info: i8MAyR+0e7MaolCZKGeWS1DsYHK4/+0PIjeLpjIO47Y=
Message-Id: <20090512094248.614764546@denx.de>
User-Agent: quilt/0.47-1
Date: Tue, 12 May 2009 11:42:49 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>
Subject: [PATCH 1/2] iproute2: Fixes an issue with cross-compilation
References: <20090512094248.439786706@denx.de>
Content-Disposition: inline; filename=01-cross-compilation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wolfgang Grandegger <wg@grandegger.com>
---
 Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: iproute2/Makefile
===================================================================
--- iproute2.orig/Makefile
+++ iproute2/Makefile
@@ -1,4 +1,5 @@
 DESTDIR=/usr/
+ROOTDIR=$(DESTDIR)
 LIBDIR=/usr/lib/
 SBINDIR=/sbin
 CONFDIR=/etc/iproute2
@@ -7,7 +8,7 @@ MANDIR=/share/man
 ARPDDIR=/var/lib/arpd
 
 # Path to db_185.h include
-DBM_INCLUDE:=/usr/include
+DBM_INCLUDE:=$(ROOTDIR)/usr/include
 
 DEFINES= -DRESOLVE_HOSTNAMES -DLIBDIR=\"$(LIBDIR)\"
 

