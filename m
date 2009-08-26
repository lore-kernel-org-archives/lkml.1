Return-Path: <linux-kernel-owner+w=401wt.eu-S1752498AbZHZRpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbZHZRpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 13:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbZHZRpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 13:45:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:60841 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbZHZRph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 13:45:37 -0400
Message-ID: <4A957479.1060206@kernel.org>
Date: Wed, 26 Aug 2009 10:44:25 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: bugzilla-daemon@bugzilla.kernel.org,
       Ricardo Jorge da Fonseca Marques Ferreira 
	<storm@sys49152.net>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, cebbert@redhat.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 13940] iwlagn and sky2 stopped working, ACPI-related
References: <bug-13940-13546@http.bugzilla.kernel.org/> <200908251555.n7PFt7Wt015763@demeter.kernel.org> <4A9425E4.40108@kernel.org>
In-Reply-To: <4A9425E4.40108@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bugzilla-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=13940
> 
> 
> 
> 
> 
> --- Comment #12 from Ricardo Ferreira <bugzillas@sys49152.net>  2009-08-26 16:54:49 ---
> Created an attachment (id=22864)
>  --> (http://bugzilla.kernel.org/attachment.cgi?id=22864)
> dmesg of not wroking kernel booted with "debug pci=earlydump"
> 
> This is of the 2.6.31-rc6 kernel with neither the patch applied or the commit
> reverted.
> 

[    0.000000] pci 0000:07:00.0 config space:
[    0.000000]   00: ab 11 55 43 07 00 10 00 12 00 00 02 10 00 00 00
[    0.000000]   10: 04 00 50 f4 00 00 00 00 01 30 00 00 00 00 00 00
[    0.000000]   20: 00 00 00 00 00 00 00 00 00 00 00 00 79 11 50 ff
[    0.000000]   30: 00 00 00 00 48 00 00 00 00 00 00 00 0b 01 00 00
[    0.000000]   40: 00 00 b0 84 09 c0 a0 01 01 5c 03 fe 00 20 00 13
[    0.000000]   50: 03 5c 00 80 00 00 00 00 00 00 04 00 05 c0 80 00
[    0.000000]   60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   70: 00 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   80: 00 00 00 00 00 30 00 00 00 00 00 00 82 a8 e8 00
[    0.000000]   90: 00 00 00 00 00 00 00 00 a0 25 26 00 00 00 00 00
[    0.000000]   a0: f6 00 00 ff 40 00 08 01 0c 31 33 40 04 0a 10 44
[    0.000000]   b0: 00 00 00 05 00 00 60 20 fa 00 00 00 00 00 00 00
[    0.000000]   c0: 10 00 12 00 c0 8f 04 05 00 20 19 00 11 ac 07 00
[    0.000000]   d0: 48 01 11 10 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   e0: 00 00 00 00 10 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000] pci 0000:08:00.0 config space:
[    0.000000]   00: 86 80 32 42 06 00 10 00 00 00 80 02 10 00 00 00
[    0.000000]   10: 04 00 60 f4 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 01 12
[    0.000000]   30: 00 00 00 00 c8 00 00 00 00 00 00 00 05 01 00 00
[    0.000000]   40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   c0: 00 00 00 00 00 00 00 00 01 d0 23 c8 00 00 00 0d
[    0.000000]   d0: 05 e0 80 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   e0: 10 00 01 00 c0 8e 00 10 10 08 19 00 11 9c 06 00
[    0.000000]   f0: 40 01 11 10 00 00 00 00 00 00 00 00 00 00 00 00


[    0.815933] pci 0000:07:00.0: reg 10 64bit mmio: [0x000000-0x003fff]
[    0.815946] pci 0000:07:00.0: reg 18 io port: [0x00-0xff]
[    0.816029] pci 0000:07:00.0: supports D1 D2
[    0.816033] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.816041] pci 0000:07:00.0: PME# disabled
[    0.816223] pci 0000:08:00.0: reg 10 64bit mmio: [0x000000-0x001fff]
[    0.816339] pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
[    0.816348] pci 0000:08:00.0: PME# disabled

not sure it is caused by acpi or mmconf...

please try to boot with pci=nommconf

YH
