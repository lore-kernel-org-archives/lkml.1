Return-Path: <linux-kernel-owner+w=401wt.eu-S933795AbXHXTL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795AbXHXTL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 15:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbXHXTLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 15:11:48 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52242 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750797AbXHXTLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 15:11:48 -0400
Date: Fri, 24 Aug 2007 20:20:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Dermot Bradley" <dermot.bradley@sla-mobile.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: "exception Emask: 0x42" errors with 2.6.22.x and SATA drives
Message-ID: <20070824202002.4d11525c@the-village.bc.nu>
In-Reply-To: <94439DDF32D7464A916B5068EFF76B3B0225E6AD@bart.tisolutions.biz>
References: <94439DDF32D7464A916B5068EFF76B3B0225E6AD@bart.tisolutions.biz>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 14:39:10 +0100
"Dermot Bradley" <dermot.bradley@sla-mobile.com> wrote:

> I've just built a new machine using a ASUS M2A-VM boardboard (ATI SB600
> chipset), AMD X2 3800+ processor, and 2 Western Digital 2.5" 80Gb drives
> running in RAID-1 using MD. I've had these problems with both 2.6.22.1
> and now 2.6.22.5 kernels.
> 
> I'm getting the following errors on occasion:
> 
> Aug 24 13:19:22 playpbx kernel: APIC error on CPU0: 00(40)
> Aug 24 13:19:33 playpbx kernel: APIC error on CPU0: 40(40)

This is not good.

> Aug 24 13:55:31 playpbx kernel: ata3.00: exception Emask 0x42 SAct
> 0x7fc77 SErr0x800 action 0x6 frozen
> Aug 24 13:55:31 playpbx kernel: ata3.00: (spurious completions during
> NCQ issue=0x0 SAct=0x7fc77 FIS=004040a1:00000008)

Probably not connected - your drive seems to be talking rubbish

Neither are good, the latter is probably a drive firmware problem and the
kernel will give up using NCQ with it if it keeps doing that, which
should be just fine.
