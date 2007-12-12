Return-Path: <linux-kernel-owner+w=401wt.eu-S1758897AbXLLKcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897AbXLLKcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 05:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbXLLKcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 05:32:01 -0500
Received: from nn7.de ([85.214.94.156]:56952 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051AbXLLKcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 05:32:00 -0500
Subject: 2.6.24-rc4: bluetooth device gone after suspend to ram
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Dec 2007 11:31:57 +0100
Message-Id: <1197455517.8814.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I noticed that on my macbook pro1,1 the bluetooth device is gone after
suspend to ram, i.e.

/usr/sbin/hciconfig -a

normally lists hci0:	Type: USB ...

but after suspend does nothing.

Here it does not help to remove the modules and to reload them. Also the
driver reloads without giving any error msg, but still nothing. As
others on mactel-users had the same problem (on mac mini/mbp2,2) it may
be worth investigating:

relevant dmesg:

Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: HCI USB driver ver 2.9

Any ideas?
Soeren
