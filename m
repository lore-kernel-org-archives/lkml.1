Return-Path: <linux-kernel-owner+w=401wt.eu-S965662AbXDMW4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965662AbXDMW4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965668AbXDMW4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:56:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51995 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965662AbXDMW4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:56:43 -0400
Subject: patch pci-add-debug-information-to-resource-collision-message.patch added to gregkh-2.6 tree
To: cebbert@redhat.com, greg@kroah.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Fri, 13 Apr 2007 15:54:18 -0700
In-Reply-To: <461B9E68.6040008@redhat.com>
Message-Id: <20070413225634.B0B90D3E31B@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: PCI: add debug information to resource collision message

to my gregkh-2.6 tree.  Its filename is

     pci-add-debug-information-to-resource-collision-message.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From cebbert@redhat.com Tue Apr 10 07:26:01 2007
From: Chuck Ebbert <cebbert@redhat.com>
Date: Tue, 10 Apr 2007 10:25:44 -0400
Subject: PCI: add debug information to resource collision message
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@atrey.karlin.mff.cuni.cz
Message-ID: <461B9E68.6040008@redhat.com>


Add more information to PCI resource collision message
to help with debugging.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/pci/i386.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/i386/pci/i386.c
+++ b/arch/i386/pci/i386.c
@@ -246,8 +246,8 @@ int pcibios_enable_resources(struct pci_
 			continue;
 		if (!r->start && r->end) {
 			printk(KERN_ERR "PCI: Device %s not available "
-				"because of resource collisions\n",
-				pci_name(dev));
+				"because of resource %d collisions\n",
+				pci_name(dev), idx);
 			return -EINVAL;
 		}
 		if (r->flags & IORESOURCE_IO)


Patches currently in gregkh-2.6 which might be from cebbert@redhat.com are

pci/pci-add-debug-information-to-resource-collision-message.patch
