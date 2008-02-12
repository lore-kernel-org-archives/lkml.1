Return-Path: <linux-kernel-owner+w=401wt.eu-S1760721AbYBLBTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760721AbYBLBTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 20:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbYBLBTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 20:19:43 -0500
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:11881
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753880AbYBLBTm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 20:19:42 -0500
X-Greylist: delayed 629 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Feb 2008 20:19:41 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAHqAsEd8qkDJ/2dsb2JhbACrDQ
X-IronPort-AV: E=Sophos;i="4.25,336,1199631600"; 
   d="scan'208";a="277133152"
X-Spam-Check-By: mail.local.tull.net
Date: Tue, 12 Feb 2008 12:08:43 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: linux-kernel@vger.kernel.org
Subject: Trivial patch to Documentation/i386/IO-APIC.txt
Message-ID: <20080212010843.GA13571@tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The description of the interrupt routing doesn't match the (nice) diagram.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>

Nick.

--- a/Documentation/i386/IO-APIC.txt	2007-10-10 06:31:38.000000000 +1000
+++ b/Documentation/i386/IO-APIC.txt	2008-02-12 11:57:08.000000000 +1100
@@ -68,7 +68,7 @@
 
 These INTA-D PCI IRQs are always 'local to the card', their real meaning
 depends on which slot they are in. If you look at the daisy chaining diagram,
-a card in slot4, issuing INTA IRQ, it will end up as a signal on PIRQ2 of
+a card in slot4, issuing INTA IRQ, it will end up as a signal on PIRQ4 of
 the PCI chipset. Most cards issue INTA, this creates optimal distribution
 between the PIRQ lines. (distributing IRQ sources properly is not a
 necessity, PCI IRQs can be shared at will, but it's a good for performance
