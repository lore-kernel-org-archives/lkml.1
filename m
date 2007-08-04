Return-Path: <linux-kernel-owner+w=401wt.eu-S1765859AbXHDWYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765859AbXHDWYe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 18:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762841AbXHDWY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 18:24:26 -0400
Received: from hu-out-0506.google.com ([72.14.214.238]:1912 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762478AbXHDWYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 18:24:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=evq7Bm/Q4D7sbPXiO79rERyxFp1EB00kkD3a/kQuJ9vTFfxx4tLCxxgPcl2xrJpm9c7VW9059gxJ7ONk4M0u465eAFP+4tY8aDPHDhKJHEDtQeSCVzJrPauOOY43jb9g8BhPKs1GAiJ1zBaEhJsqew7U/JRzqIroN44N2g9ul58=
Date: Sun, 5 Aug 2007 02:24:28 +0400
From: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: x86_64: HPET is detected but not working on ASUS F3T notebook
Message-ID: <20070805022428.6b50ec31@localhost>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

HPET is not working on my notebook with 64-bit kernel. HPET is detected
by kernel

  # dmesg | grep -i hpet
  ACPI: HPET 3FFA9760, 0038 (r1 A M I  OEMHPET0  4000724 MSFT 97)
  ACPI: HPET id: 0x10de8201 base: 0xfed00000
  hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
  hpet0: 3 32-bit timers, 25000000 Hz
  Time: hpet clocksource has been installed.
  hpet_resources: 0xfed00000 is busy

but not listed in /proc/timer_list. When i use HRT (tickless) kernel
patches the system stall at boot until i press and hold any key.
I test every HRT kernel starting from linux-2.6.22-rc3-hrt1
with the same result.


PS: i386 kernel with similar configuration works with HPET without any
trouble.


Sincerely yours,
Mikhail Kshevetskiy
