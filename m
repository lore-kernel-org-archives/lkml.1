Return-Path: <linux-kernel-owner+w=401wt.eu-S1030755AbXDZMaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030755AbXDZMaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 08:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030777AbXDZMaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 08:30:13 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1675 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030761AbXDZMaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 08:30:12 -0400
Message-ID: <46309B59.4090701@shadowen.org>
Date: Thu, 26 Apr 2007 13:30:17 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm2 -- x86_64 blade hard hangs
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
In-Reply-To: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Getting hard boot failures before any kernel output on an x86_64 blade:

root (hd0,0)
 Filesystem type is ext2fs, partition type 0x83
kernel /vmlinuz-autobench ro root=/dev/VolGroup00/LogVol00 rhgb
console=tty0 console=ttyS1,19200 selinux=no autobench_args:
root=30726124 ABAT:1177507960 profile=2
   [Linux-bzImage, setup=0x1e00, size=0x21fe48]
initrd /initrd-autobench.img
   [Linux-initrd @ 0x37e5f000, 0x190984 bytes]
[silence]

Kernel config is here:

http://test.kernel.org/abat/85082/build/dotconfig

-apw
