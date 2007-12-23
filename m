Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbXLWAFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbXLWAFm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 19:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbXLWAFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 19:05:35 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:46021 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752598AbXLWAFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 19:05:34 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.24-rc6
Date: Sun, 23 Dec 2007 02:05:12 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       maxk@qualcomm.com, marcel@holtmann.org
References: <alpine.LFD.0.9999.0712201731010.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712201731010.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200712230205.15486.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

21 Ara 2007 Cum tarihinde, Linus Torvalds şunları yazmıştı: 
> Here's to a merry christmas, doing the whole druidic festival around the
> tree thing,

With -rc6, dmesg shows following Unknown symbols;

[...]
[   26.883635] Bluetooth: Core ver 2.11
[   26.913123] hci_usb: Unknown symbol hci_suspend_dev
[   26.913155] hci_usb: Unknown symbol hci_free_dev
[   26.913495] hci_usb: Unknown symbol hci_resume_dev
[   26.913566] hci_usb: Unknown symbol hci_alloc_dev
[   26.913696] hci_usb: Unknown symbol hci_unregister_dev
[   26.913775] hci_usb: Unknown symbol hci_recv_fragment
[   26.913841] hci_usb: Unknown symbol hci_register_dev
[   26.914117] hci_usb: Unknown symbol hci_suspend_dev
[   26.914148] hci_usb: Unknown symbol hci_free_dev
[   26.914477] hci_usb: Unknown symbol hci_resume_dev
[   26.914548] hci_usb: Unknown symbol hci_alloc_dev
[   26.914678] hci_usb: Unknown symbol hci_unregister_dev
[   26.914757] hci_usb: Unknown symbol hci_recv_fragment
[   26.914823] hci_usb: Unknown symbol hci_register_dev
[   26.915070] hci_usb: Unknown symbol hci_suspend_dev
[   26.915101] hci_usb: Unknown symbol hci_free_dev
[   26.915429] hci_usb: Unknown symbol hci_resume_dev
[   26.915501] hci_usb: Unknown symbol hci_alloc_dev
[   26.915630] hci_usb: Unknown symbol hci_unregister_dev
[   26.915709] hci_usb: Unknown symbol hci_recv_fragment
[   26.915776] hci_usb: Unknown symbol hci_register_dev
[   26.928322] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   26.937433] ACPI: Thermal Zone [TZS0] (62 C)
[   26.942470] ACPI: Thermal Zone [TZS1] (66 C)
[   26.982668] NET: Registered protocol family 31
[   26.982671] Bluetooth: HCI device and connection manager initialized
[   26.982675] Bluetooth: HCI socket layer initialized
[   27.043943] Bluetooth: HCI USB driver ver 2.9
[   27.074386] usbcore: registered new interface driver hci_usb
[...]

A Google search found [1] and according to that old thread, its either a 
general module problem [2] or a module-init-tools (I'm using vanilla 
module-init-tools 3.3_pre11) problem [3]. 

I'm not sure whether its a user-space problem or these caused by bluetooth 
module's initialization phase so i decided to report LKML :). 

Although these shown in kern.log, bluetooth subsystem works without a problem.

You can find .config and full dmesg output from [4] and if anything else is 
needed, please just say it.

[1] http://osdir.com/ml/linux.bluez.devel/2004-10/msg00043.html
[2] http://osdir.com/ml/linux.bluez.devel/2004-10/msg00047.html
[3] http://osdir.com/ml/linux.bluez.devel/2004-10/msg00054.html
[4] http://cekirdek.pardus.org.tr/~caglar/kernel/

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
