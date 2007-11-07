Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbXKGRLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbXKGRLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbXKGRL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:11:28 -0500
Received: from rtr.ca ([76.10.145.34]:1758 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273AbXKGRL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:11:27 -0500
Message-ID: <4731F1BD.2070902@rtr.ca>
Date: Wed, 07 Nov 2007 12:11:25 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: romieu@fr.zoreil.com, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: r8169:  NFG in 2.6.24-rc2
References: <4731E2AB.5080703@rtr.ca>
In-Reply-To: <4731E2AB.5080703@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> My ASUS board has one of these:
> 
> 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
> RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
>        Subsystem: ASUSTeK Computer Inc. Unknown device 81aa
>        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
..
>     ...
>     r8169: eth0: link up
>     ...
>     kernel: NETDEV WATCHDOG: eth0: transmit timed out
>     r8169: eth0: link up
>     ...
> Not usable from this point on.
> 
> With CONFIG_PCI_MSI=y, it also fails, and then isn't even detected (not in lspci)
> on subsequent reboots.  A power cycle is required to get it to show up  again.
..

Ahh.. this seems to have been around for a while already,
as there's an unresolved bug entry from -rc1 for this exact problem.

http://bugzilla.kernel.org/show_bug.cgi?id=9257
