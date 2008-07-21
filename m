Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbYGUCO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbYGUCO1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 22:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758702AbYGUCOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 22:14:16 -0400
Received: from relay2.globalproof.net ([194.146.153.25]:44334 "EHLO
	relay2.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758700AbYGUCOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 22:14:16 -0400
X-Greylist: delayed 1108 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jul 2008 22:14:15 EDT
From: nuclearcat@nuclearcat.com
To: linux-kernel@vger.kernel.org
Subject: blackfin and USB
Date: Mon, 21 Jul 2008 04:55:38 +0300
User-Agent: KMail/1.9.9
Cc: idan@nicta.com.au, rgetz@blackfin.uclinux.org, cooloney@kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807210455.38681.nuclearcat@nuclearcat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there

I am trying to configure kernel for Blackfin (BF533). I cannot enable USB driver for host (any) till i enable PCI (and in fact there is no PCI on blackfin).
Even if i enable it, i will have:

  CC      drivers/pci/access.o
  CC      drivers/pci/bus.o
  CC      drivers/pci/probe.o
drivers/pci/probe.c: In function 'pci_scan_slot':
drivers/pci/probe.c:1024: error: implicit declaration of function 'pcibios_scan_all_fns'

I guess there must be a way to enable devices without enabling PCI (logically correct), or it must not call this function.

I am using 2.6.26 vanilla kernel. 
Btw is networking works on Blackfin with vanilla?
