Return-Path: <linux-kernel-owner+w=401wt.eu-S1762429AbXGNMJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762429AbXGNMJd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 08:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757767AbXGNMJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 08:09:23 -0400
Received: from lucidpixels.com ([75.144.35.66]:40251 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757710AbXGNMJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 08:09:19 -0400
Date: Sat, 14 Jul 2007 08:09:18 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
cc: apiszcz@solarrain.com
Subject: 2.6.22.1: Enabling IO-APIC = APIC error on CPU0: 40(40)
Message-ID: <Pine.LNX.4.64.0707140758110.22713@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have an older MSI motherboard and when I enable the following option:

>From lshw:
        description: Motherboard
        product: MS-6730

[*]   IO-APIC support on uniprocessors

I get the following errors in dmesg:

[  247.177372] APIC error on CPU0: 00(40)
[  247.556741] APIC error on CPU0: 40(40)
[  262.010412] APIC error on CPU0: 40(40)
[  262.765553] APIC error on CPU0: 40(40)
[  263.876481] APIC error on CPU0: 40(40)
[  264.191962] APIC error on CPU0: 40(40)
[  265.040566] APIC error on CPU0: 40(40)
[  267.959689] APIC error on CPU0: 40(40)
[  269.446029] APIC error on CPU0: 40(40)
[  269.853344] APIC error on CPU0: 40(40)
[  271.122825] APIC error on CPU0: 40(40)
[  271.287051] APIC error on CPU0: 40(40)
[  273.825237] APIC error on CPU0: 40(40)
[  274.373737] APIC error on CPU0: 40(40)
[  275.355775] APIC error on CPU0: 40(40)
[  275.982087] APIC error on CPU0: 40(40)
[  276.101181] APIC error on CPU0: 40(40)
[  276.173611] APIC error on CPU0: 40(40)
[  276.970970] APIC error on CPU0: 40(40)
[  277.561575] APIC error on CPU0: 40(40)
[  278.694486] APIC error on CPU0: 40(40)
[  279.353573] APIC error on CPU0: 40(40)
[  281.779398] APIC error on CPU0: 40(40)
[  283.625457] APIC error on CPU0: 40(40)
[  284.749322] APIC error on CPU0: 40(40)
[  284.983013] APIC error on CPU0: 40(40)
[  285.126394] APIC error on CPU0: 40(40)

I normally do not use this option (which also gets rid of the errors*1), 
but I am curious, why do these errors occur?  I remember them with the early
2.6.x series and they are still re-occurring in 2.6.22.1.

The weird part-- is when IO-APIC is disabled, I see this on boot:

IO-APIC DISABLED:

[   46.902712] XFS mounting filesystem md0
[   47.017322] spurious 8259A interrupt: IRQ7.
[   47.273009] Ending clean XFS mount for filesystem: md0

IO-APIC ENABLED:

[   46.851012] XFS mounting filesystem md0
[   47.103066] Ending clean XFS mount for filesystem: md0

* 1 Anytime I see a spurious interrupt on (usually older hardware) 
especially during file I/O this usually means corruption (from what I 
have seen) that is why I don't really want to trust anything on this host.

Anyone have any idea what's going on here?

Justin.
