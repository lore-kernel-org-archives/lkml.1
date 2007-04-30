Return-Path: <linux-kernel-owner+w=401wt.eu-S1423305AbXD3OgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423305AbXD3OgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423311AbXD3Ofk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:35:40 -0400
Received: from smtp-out.google.com ([216.239.45.13]:45574 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423315AbXD3OfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:35:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=WqKopX761VSVq0V+RhFhxMpIZ1xgsZ6qWjCRumqJOU9sUWFhA7gflheH9se5yUGFY
	2biuXtNwphmLCi9Gisaew==
Date: Mon, 30 Apr 2007 07:34:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: [patch] pci: type may be unused in pci_access_init()
Message-ID: <Pine.LNX.4.64.0704291659480.1822@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The automatic 'type' variable is unused in !CONFIG_PCI_DIRECT and
!CONFIG_PCI_MMCONFIG.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/i386/pci/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/i386/pci/init.c b/arch/i386/pci/init.c
--- a/arch/i386/pci/init.c
+++ b/arch/i386/pci/init.c
@@ -6,7 +6,7 @@
    in the right sequence from here. */
 static __init int pci_access_init(void)
 {
-	int type = 0;
+	int type __attribute__((unused)) = 0;
 
 #ifdef CONFIG_PCI_DIRECT
 	type = pci_direct_probe();
