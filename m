Return-Path: <linux-kernel-owner+w=401wt.eu-S932423AbYBONZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423AbYBONZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 08:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761608AbYBONZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 08:25:38 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:9237 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760533AbYBONZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 08:25:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=CTskPFae8lm0hHgCIy8Pu1K+mtffvALOcpE0dpyX3ymUqDqhJRCvgdBctT+beWuih0QPUyTX2dC87BqSpp/FIUcCiE9kutSm5CM6BIMxvUEda+j50RawrkexIvEmFYHs0WE0yPJK7Y+T9hIXQ/MTaRxJjxuo84JkHCKyJKovjPA=
Message-ID: <20cbb9450802150525g1e197b1dwed82afac91bfa7b0@mail.gmail.com>
Date: Fri, 15 Feb 2008 18:25:34 +0500
From: "Shahbaz Khan" <shaz.linux@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: TPM-IMA Setup Problems
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the past 2 days I am trying to configure IMA on Dell Optiplex 745
with Broadcom TPM. The kernel version is 2.6.20-rc4-mm1 + all the
tpm3.2.0 patches from IBM IMA webpage. I've been through so much that
can't remember all but currently I can't find any braodcom tpm driver
modules and tpm_tis seems to be able to get to the TPM chip. I am
getting the following message on

[       ]# init_tpm /etc/bootkeys:
[       ]Unexpected error code 35


I am also encounterring IRQ conflicts of TPM with sometimes rtc, hdc,
fd0. It looks like this in /proc/interrupts:

           CPU0       CPU1
  0:     124995     105404   IO-APIC-edge      timer
  1:          2          0   IO-APIC-edge      i8042
  7:          1          0   IO-APIC-edge      parport0
  8:          3          0   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 11:	      3		 0   		                tpm0	
 12:          7          0   IO-APIC-edge      i8042
 14:      27408       1694   IO-APIC-edge      ide0
 16:         99          0   IO-APIC-fasteoi   uhci_hcd:usb1, HDA Intel
 17:          0          0   IO-APIC-fasteoi   uhci_hcd:usb2, uhci_hcd:usb4
 18:          2          0   IO-APIC-fasteoi   uhci_hcd:usb3, ehci_hcd:usb7
 19:        799        587   IO-APIC-fasteoi   uhci_hcd:usb5
 20:          0          0   IO-APIC-fasteoi   ehci_hcd:usb6
220:          4          0   PCI-MSI-edge      eth0
NMI:          0          0
LOC:     230430     230419
ERR:          0
MIS:          0

Any suggestions?
