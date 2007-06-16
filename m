Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbXFPJPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbXFPJPs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 05:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbXFPJPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 05:15:38 -0400
Received: from postfix2-g20.free.fr ([212.27.60.43]:35252 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbXFPJPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 05:15:37 -0400
Message-ID: <1181985273.4673a9f9e9a4e@imp.free.fr>
Date: Sat, 16 Jun 2007 11:14:33 +0200
From: castet.matthieu@free.fr
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-net@vger.kernel.org
Subject: FW : airo suspend problem
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 81.57.151.96
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Sujet : airo suspend problem
      À : linux-pm@lists.osdl.org

Hi,

the airo driver (drivers/net/wireless/airo.c) does in its suspend routine [1].
But not all the pci cards support power management and cause
pci_enable_wake/pci_set_power_state to return errors.

On pci card that don't support PM, what should be done ?
Don't call pci_enable_wake/pci_set_power_state ?


Thanks

Matthieu


PS : after the failed suspend to ram due to airo driver, I tried to unload airo
driver and it hanged. After a reset, I got my ext3 root fs corrupted :(




[1]
pci_enable_wake(pdev, pci_choose_state(pdev, state), 1);
pci_save_state(pdev);
return pci_set_power_state(pdev, pci_choose_state(pdev, state));



