Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbZFVLxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbZFVLxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZFVLxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:53:42 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:35881 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbZFVLxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:53:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GdYyUiWpbT8fhUKwa89Um1j/XJ7YSAjvxCrYXOqxiRvkiZsbTsyCt0lkFDMU5/CM11
         F9GB5UwkNYnSu64tz7LXScT/fdk+EEbsh8sKzJ+2uXcidm1Z9+Gsr62UpEQisQqiEgl4
         dBMpZOnbJRvFGC6ZsoJUkpCCp/jdjaNu7mtbg=
MIME-Version: 1.0
In-Reply-To: <4A3F55C7.4030909@linux.intel.com>
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>
	 <4A3E7F38.7030300@linux.intel.com>
	 <8db1092f0906211313x73ac9340n9af5775b56cfd189@mail.gmail.com>
	 <4A3EE668.5090400@jp.fujitsu.com>
	 <8db1092f0906220019x1560c26dsd5a6daa3ea612ec@mail.gmail.com>
	 <4A3F55C7.4030909@linux.intel.com>
Date: Mon, 22 Jun 2009 13:53:42 +0200
Message-ID: <8db1092f0906220453k5595998er1400567cbcdf3e12@mail.gmail.com>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend to 
	disk, mce related?
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/22 Andi Kleen <ak@linux.intel.com>:

>
> Too bad. Were you able to set up a console during the hang?
>
> e.g. if you have a second system could you perhaps configure netconsole
> (See Documentation/networking/netconsole.txt) and capture the messages?
>

I configure netconsole. But it doesn't show any messages when system hangs:

[...]
[   54.115003] PM: Restoring platform NVS memory
[   54.120959] Booting processor 1 APIC 0x1 ip 0x6000
[   54.113855] CPU: L1 I cache: 32K, L1 D cache: 32K
[   54.113855] CPU: Processor Core ID: 1
[   54.113855] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[   54.216141] CPU1 is up
[   54.218135] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
[   54.272099] usb usb3: root hub lost power or was reset
[   54.272227] ehci_hcd 0000:00:1d.7: PME# disabled
[   54.277797] r8169 0000:02:00.0: PME# disabled
[   54.279176] parport_pc 00:08: activated
[   54.430512] ata2.01: ACPI cmd ef/03:44:00:00:00:b0 filtered out
[   54.433320] ata2.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
[   54.443411] ata2.00: configured for UDMA/100
[   54.446252] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
[   54.481479] sd 1:0:0:0: [sdb] Starting disk
[   55.799953] btusb 4-1:1.1: no reset_resume for driver btusb?
[   57.247203] Restarting tasks ... done.


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
