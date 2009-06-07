Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbZFGItF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbZFGItF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 04:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbZFGIsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 04:48:55 -0400
Received: from senator.holtmann.net ([87.106.208.187]:50334 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbZFGIsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 04:48:55 -0400
Subject: Re: usb fails to suspend [was: mmotm 2009-06-05-16-19]
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "rjw@sisk.pl" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <4A2AA469.5020709@gmail.com>
References: <4A2AA469.5020709@gmail.com>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 10:48:19 +0200
Message-Id: <1244364499.23850.83.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> there is a suspend regression somewhere between mmotm 2009-05-17-12-15
> and 2009-06-05-16-19:
> hcd_pci_suspend_noirq(): pci_prepare_to_sleep+0x0/0x80 returns -19
> pci_pm_suspend_noirq(): hcd_pci_suspend_noirq+0x0/0xb0 returns -19
> pm_noirq_op(): pci_pm_suspend_noirq+0x0/0x180 returns -19
> PM: Device 0000:00:1d.2 failed to suspend late: error -19
> 
> $ lspci -xxvvs 0000:00:1d.2
> 00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #3 (rev 02) (prog-if 00 [UHCI])
>         Subsystem: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #3

what is the likelihood that you have an Intel WiMAX card in this system?
There is a suspend issue when i2400m_usb is loaded. Took me a while to
figure that one out. It suspends/resumes fine for the first time after
reboot, but on resume it deadlocks the whole USB subsystem.

Regards

Marcel


