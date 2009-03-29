Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbZC2Pk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbZC2Pk1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 11:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755128AbZC2PkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 11:40:15 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:34345 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZC2PkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 11:40:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nQNMB2mt19T105FzAT9CWH5UqeawIbOCCL1Wfkc4880jFY09D57OGmcIBK+egZACwS
         /4XrJGZ7G+cFj0bSMjKTnbE5Rvuk1uNq2J4TKgJfZ8NsFNdz6zcWqR0N1bbB4FWjzvo6
         KLf1+KCYPTu3JQQW0wA1+N/+idbwMg8c0TjBI=
MIME-Version: 1.0
Date: Sun, 29 Mar 2009 17:40:10 +0200
Message-ID: <4e5e476b0903290840o453bcccdm5800a636078fde6e@mail.gmail.com>
Subject: How to debug kernel startup time?
From: Corrado Zoccolo <czoccolo@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm seeing around 2 s "lost" during kernel boot, that are not
accounted for any init call (excerpt of dmesg with initcall_debug
follows, kernel is 2.6.29).
What's the suggested way to investigate such problems?

Thanks,
Corrado

[    1.797146] calling  tcp_congestion_default+0x0/0xf @ 1
[    1.797279] initcall tcp_congestion_default+0x0/0xf returned 0 after 48 usecs
[    1.911721] mmc0: new SDHC card at address b368
[    1.912155] mmcblk0: mmc0:b368 SDC   7.46 GiB
[    1.912293]  mmcblk0: p1
[    2.095702] usb 1-5: New USB device found, idVendor=064e, idProduct=d101
[    2.095801] usb 1-5: New USB device strings: Mfr=3, Product=1, SerialNumber=4
[    2.095902] usb 1-5: Product: Acer Crystal Eye webcam
[    2.095980] usb 1-5: Manufacturer: SuYin
[    2.096053] usb 1-5: SerialNumber: CN0316-M608-OV01-VA-R02.00.00
[    2.096440] usb 1-5: configuration #1 chosen from 1 choice
[    2.500110] Clocksource tsc unstable (delta = -282878412 ns)
[    3.946532] Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1,
caps: 0xd04771/0xa40000
[    4.005707] input: SynPS/2 Synaptics TouchPad as /class/input/input7
[    4.540135] async_waiting @ 1
[    4.540226] async_continuing @ 1 after 1 usec
[    4.544604] kjournald starting.  Commit interval 5 seconds
[    4.544697] EXT3-fs: mounted filesystem with ordered data mode.
[    4.544792] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
[    4.544917] async_waiting @ 1
[    4.544991] async_continuing @ 1 after 1 usec
[    4.545222] Freeing unused kernel memory: 276k freed
[    4.545430] Write protecting the kernel text: 3128k
[    4.545576] Write protecting the kernel read-only data: 1480k

-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
