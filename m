Return-Path: <linux-kernel-owner+w=401wt.eu-S1765209AbZDHUyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765209AbZDHUyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 16:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760393AbZDHUyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 16:54:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:36133 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbZDHUyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 16:54:32 -0400
Message-Id: <E942C580-7C39-44AB-B207-C65CDE0B5292@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: tracking of PCI address space
Date: Wed, 8 Apr 2009 15:53:55 -0500
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was wondering if we have anything that tracks regions associated  
with the "inbound" side of a pci_bus.

What I mean is on embedded PPC we have window/mapping registers for  
both inbound (accessing memory on the SoC) and outbound (access PCI  
device MMIO, IO etc).  The combination of the inbound & outbound  
convey what exists in the PCI address space vs CPU physical address  
space (and how to map from one to the other).  Today in the PPC land  
we only attach outbound windows to the pci_bus.  So technically the  
inbound side information (like what subset of physical memory is  
visible on the PCI bus) seems to be lost.

- k
