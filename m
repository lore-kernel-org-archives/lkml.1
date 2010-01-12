Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549Ab0ALDPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab0ALDPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 22:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448Ab0ALDPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 22:15:32 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:43727 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab0ALDPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 22:15:31 -0500
Date: Mon, 11 Jan 2010 22:15:13 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Christian Kujau <lists@nerdbynature.de>
Cc: robert.moore@intel.com, werner <w.landgraf@ru.ru>, ming.m.lin@intel.com,
       len.brown@intel.com, linux-kernel@vger.kernel.org
Subject: Re: kernel problem 2.6.33-rc2
In-reply-to: <4B3C722F.80406@nerdbynature.de>
Message-id: <alpine.LFD.2.00.1001112214110.29790@localhost.localdomain>
References: <web-122504368@zbackend1.aha.ru> <4B3C722F.80406@nerdbynature.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



thanks,
Len Brown, Intel Open Source Technology Center

On Thu, 31 Dec 2009, Christian Kujau wrote:

> werner wrote on 2009-12-24 21:37 :
> > kernel 2.6.33-rc2 crashs during boot.
> > With 2.6.33-rc1 this didn't happen
> > 
> > Code: 04 4e 85 f6 75 b9 c6 01 00 31 c0 5b (or 56 I cannot more read my
> > own hand-writing) 5e 5f 5d c3 55 89
> > e5 e8 33 5f 9f ff 89 c2 8d 40 ff 83 f8 fd 76 07 a1 50 f8 2f c2 eb 0a 89
> > d0 .LT.80.GT. 78 04 0f 74 02 31 c0 5d c3 55 89 e5 e8 0e 5f 9f ff 31 d2 85
> > 
> > EIP c160db30 acpi_ns_validate_handle +0x1b/0x25
> > CR2: 0c204 SS:ESP 0068: f282ff28
> > end trace 234c0a11060036b6 (or bbb or 6bb)
> > pid: 1 comm: swapper tained: G D 2.6.33-rc2 #1
> 
> Not sure about the timeline of -git14 here, but could this be somehow related
> to:

is there some evidence that suggests that this commit is related to the 
issue?

thanks,
-Len

> > commit f24b664dc44a4ab4df61db2258cea298eeb43a8e
> Author: Bob Moore <robert.moore@intel.com>
> Date:   Fri Dec 11 14:57:00 2009 +0800
> 
>     ACPICA: Update internal namespace node/handle interfaces
> 
>     This change deletes the unnecessary acpi_ns_convert_entry_to_handle
>     interface and renames the acpi_ns_map_handle_to_node interface to
>     acpi_ns_validate_handle.  ACPICA BZ 798.
> 
>     http://www.acpica.org/bugzilla/show_bug.cgi?id=798
> 
>     Signed-off-by: Bob Moore <robert.moore@intel.com>
>     Signed-off-by: Lin Ming <ming.m.lin@intel.com>
>     Signed-off-by: Len Brown <len.brown@intel.com>
> 
> 
> > c1c6e747 printk +0x14/0x16
> > c6e689 panic +0x3e/0xe8
> > 04000f do_exit 0x61/0x5e6
> > c103dfeb kmsg_dump 0xfa/0x10e
> > 103d236 cups exit 0x2f/0x34
> > 006104 oops end 0x83/0x8a
> > c6e747 printk 0x14 0x16
> > 0276ad (ou bad) no context 0x144/0x14e
> > now i'm tired to copy this all, the next beginning numbers are:
> > c1039fbe 02780e c6f31f 03329b c706c2 03329b 027828 027ab3 02798b c71313
> > 60db30 60d00d c219da02 c1b5428e b52b0a b5434c
> > c219db2b dell_wmi_init 0x129/0x131 (see you the problems, I dont like dell)
> > c1001143 do_one_initcall 0x51 / 0x13f
> > c213d301 kernel_init 0x10a / 0x15e
> > c1003a46 kenel_thread helper 0x6 / 0x10
> > 
> > W.Landgraf
> > use Linux SYS !!!
> > mirror: ftp://ftp5.gwdg.de/pub/linux/install/sys
> > ---
> > Professional hosting for everyone - http://www.host.ru
> 
> -- 
> make bzImage, not war
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
