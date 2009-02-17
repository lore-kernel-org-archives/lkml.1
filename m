Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbZBQQ5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbZBQQ5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 11:57:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbZBQQ4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 11:56:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35644 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbZBQQ4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 11:56:41 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/3] MN10300: Fix typo && -> || in
	arch/mn10300/unit-asb2305/pci.c
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       Wei Yongjun <yjwei@cn.fujitsu.com>, David Howells <dhowells@redhat.com>
Date: Tue, 17 Feb 2009 16:56:03 +0000
Message-ID: <20090217165603.17657.11820.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090217165552.17657.90940.stgit@warthog.procyon.org.uk>
References: <20090217165552.17657.90940.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>

Fix the typo && -> ||.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/unit-asb2305/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/mn10300/unit-asb2305/pci.c b/arch/mn10300/unit-asb2305/pci.c
index 1a86425..07dbbcd 100644
--- a/arch/mn10300/unit-asb2305/pci.c
+++ b/arch/mn10300/unit-asb2305/pci.c
@@ -173,7 +173,7 @@ static int pci_ampci_write_config_byte(struct pci_bus *bus, unsigned int devfn,
 		BRIDGEREGB(where) = value;
 	} else {
 		if (bus->number == 0 &&
-		    (devfn == PCI_DEVFN(2, 0) && devfn == PCI_DEVFN(3, 0))
+		    (devfn == PCI_DEVFN(2, 0) || devfn == PCI_DEVFN(3, 0))
 		    )
 			__pcidebug("<= %02x", bus, devfn, where, value);
 		CONFIG_ADDRESS = CONFIG_CMD(bus, devfn, where);

