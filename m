Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbYJaHkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbYJaHkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 03:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYJaHjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 03:39:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:4230 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbYJaHjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 03:39:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=odpezsBEpPr3tRyQJrUIrTNwCivVAwj7fRsPI2WU1y9jCmmXyNs9vs7DJI5i476HcU
         gEu/VgZ+EQCX0l3jp6E//cNQQVNusbSAbzhXzpm+AN4LelItjGSIDM7PXo63iByfwMiI
         ELHpDviGKta1WIerNb2HcNW7TDszpat0xyw8g=
Date: Fri, 31 Oct 2008 05:39:50 -0200
From: Rafael Cunha de Almeida <almeidaraf@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Weird behaviour on iwl3945 module
Message-Id: <20081031053950.e2d22e55.almeidaraf@gmail.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm using Debian lenny (linux 2.6.26) and I have a iwl3945 wireless
card. My laptop is a lenovo r61i. I've notice that, when I turn off
the wireles/bluetooth switch the wireless module isn't removed, the
kernel even displays a few warnings:

% dmesg | tail -n11
[ 1219.735652] iwl3945: Radio Frequency Kill Switch is On:
[ 1219.735652] Kill switch must be turned off for wireless networking to work.
[ 1219.787767] usb 1-1: USB disconnect, address 2
[ 1221.291865] iwl3945: WARNING: Requesting MAC access during RFKILL wakes up NIC
[ 1221.294246] iwl3945: MAC is in deep sleep!
[ 1221.341983] iwl3945: WARNING: Requesting MAC access during RFKILL wakes up NIC
[ 1221.345953] iwl3945: MAC is in deep sleep!
[ 1221.405968] iwl3945: WARNING: Requesting MAC access during RFKILL wakes up NIC
[ 1221.450835] iwl3945: MAC is in deep sleep!
[ 1221.612230] iwl3945: WARNING: Requesting MAC access during RFKILL wakes up NIC
[ 1221.632612] ACPI: PCI interrupt for device 0000:03:00.0 disabled

So, when I turn the switch back on, my wireless card is not
operational. I have to manually remove and then reinstall the iwl3945
module in order to the device to resume working. The bluetooth device
doesn't have that issue.

Is that an expected behaviour? Would it be impossible or undesirable
to the kernel to behave differently? Is it already fixed in the newest
kernel version (or on the -mm branch)? I am willing to hack into the
kernel code in order to fix that problem, if someone would give me
pointers of where to start.

[]'s
Rafael
