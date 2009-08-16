Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZHPPED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZHPPED (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 11:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbZHPPEC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 11:04:02 -0400
Received: from khc.piap.pl ([195.187.100.11]:39151 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbZHPPEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 11:04:01 -0400
To: <linux-kernel@vger.kernel.org>
Subject: Reservation of resources shared by two PCI devices
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 16 Aug 2009 17:04:00 +0200
Message-ID: <m3bpmfhkbj.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a PCI card with a bridge and two devices behind it.
There is a custom circuitry connected to the first PCI device,
controlling operation of both devices.

The IO and possibly MMIO resources used for controlling the custom
circuitry (part of device #0 registers) are not used for other purposes.
Access is controlled by a spin lock.

What's the best way to handle IO/MMIO resource reservations of this
shared part of device #0?

Should I switch away from pci_register_driver()?
-- 
Krzysztof Halasa
