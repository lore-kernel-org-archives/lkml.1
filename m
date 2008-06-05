Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbYFEGAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbYFEGAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 02:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbYFEGAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 02:00:34 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:57285 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbYFEGAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 02:00:33 -0400
Date: Thu, 05 Jun 2008 02:00:31 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: Kernel GPF ACPI
In-reply-to: <alpine.LFD.1.10.0806050152510.4914@localhost.localdomain>
X-X-Sender: lenb@localhost.localdomain
To: Mike White <argentia@operamail.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.1.10.0806050158160.4914@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20080603021645.A63FDCBC9E@ws5-11.us4.outblaze.com>
 <alpine.LFD.1.10.0806050152510.4914@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > Jun  2 00:51:01 deathscape kernel: Call Trace:
> > Jun  2 00:51:01 deathscape kernel:  [<ffffffff8033321e>] acpi_get_data+0x3e/0x6e
> > Jun  2 00:51:01 deathscape kernel:  [<ffffffff8033e980>] acpi_bus_get_device+0x25/0x68
> > Jun  2 00:51:01 deathscape kernel:  [<ffffffff880135c5>] :thermal:acpi_thermal_trip_seq_show+0x12b/0x257
> > Jun  2 00:51:01 deathscape kernel:  [<ffffffff802a19c2>] seq_read+0x105/0x28b
> > Jun  2 00:51:01 deathscape kernel:  [<ffffffff8028943d>] vfs_read+0xcb/0x153
> > Jun  2 00:51:01 deathscape kernel:  [<ffffffff802897d1>] sys_read+0x45/0x6e
> > Jun  2 00:51:01 deathscape kernel:  [<ffffffff80209dac>] tracesys+0xdc/0xe1
> > Jun  2 00:51:01 deathscape kernel: 
> > Jun  2 00:51:01 deathscape kernel: 
> > Jun  2 00:51:01 deathscape kernel: Code: 80 7f 08 0f 48 0f 44 c7 c3 48 89 f8 c3 31 c0 48 85 ff 74 0d 
> > Jun  2 00:51:01 deathscape kernel: RIP  [<ffffffff80333fda>] acpi_ns_map_handle_to_node+0x14/0x1d
> > Jun  2 00:51:01 deathscape kernel:  RSP <ffff810111ae7e10>
> > 
> 
> searching for acpi_thermal_trip_seq_show on kerneloops.org shows that this
> may still be a problem -- at least up through 2.6.24.

ah yes, I thought this rang a bell...

Happily I find that kerneloops now has links to bugzilla -- sorry i didn't 
my previous message...

This issue should be gone as of 2.6.25, please let me know if it isn't.

https://bugzilla.novell.com/show_bug.cgi?id=350017
http://bugzilla.kernel.org/show_bug.cgi?id=10252

thanks,
-Len

