Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbXFLHOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbXFLHOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbXFLHOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:14:41 -0400
Received: from bay0-omc1-s21.bay0.hotmail.com ([65.54.246.93]:22150 "EHLO
	bay0-omc1-s21.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750776AbXFLHOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:14:41 -0400
Message-ID: <BAY103-DAV164930BAD25A9841FEF442B2190@phx.gbl>
X-Originating-IP: [85.36.106.198]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: "David Chinner" <dgc@sgi.com>
Cc: "David Chinner" <dgc@sgi.com>, <linux-kernel@vger.kernel.org>,
       <xfs@oss.sgi.com>, "Marco Berizzi" <pupilla@hotmail.com>
References: <BAY103-DAV1066400DF0615AD677EA1B2730@phx.gbl> <20070316012520.GN5743@melbourne.sgi.com> <BAY103-DAV13EC09E9BCB3E8C9D5EEA2B2710@phx.gbl> <20070316195951.GB5743@melbourne.sgi.com> <BAY103-DAV1484A3797D5368C28969CBB2700@phx.gbl> <BAY103-DAV9C465F21C87A900314523B2760@phx.gbl> <20070320064632.GO32602149@melbourne.sgi.com> <BAY103-DAV7076D9B4230E07680B724B2260@phx.gbl> <20070607130505.GE85884050@sgi.com> <BAY103-DAV141D991980E54836534A00B2250@phx.gbl> <20070612061440.GQ86004887@sgi.com>
Subject: Re: XFS internal error xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller 0xc01b00bd
Date: Tue, 12 Jun 2007 09:14:27 +0200
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1123
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1123
X-OriginalArrivalTime: 12 Jun 2007 07:14:40.0432 (UTC) FILETIME=[57C19B00:01C7ACC1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:

> On Fri, Jun 08, 2007 at 03:59:39PM +0200, Marco Berizzi wrote:
> > David Chinner wrote:
> > > Where we saw signs of on disk directory corruption. Have you run
> > > xfs_repair successfully on the filesystem since you reported
> > > this?
> >
> > yes.
> >
> > > If you did clean up the error, does xfs_repair report the same
sort
> > > of error again?
> >
> > I have run xfs_repair this morning.
> > Here is the report:
>
> <reports no on disk errors>
>
> > > Have you run a 2.6.16-rcX or 2.6.17.[0-6] kernel since you last
> > > reported this problem?
> >
> > No. I have run only 2.6.19.x and 2.6.21.x
> >
> > After the xfs_repair I have remounted the file system.
> > After few hours linux has crashed with this message:
> > BUG: at arch/i386/kernel/smp.c:546 smp_call_function()
> > I have also the monitor bitmap.
>
> This is sounding like memory corruption is no corruption is being
> found on disk by xfs_repair.  Have you run memtest86 on that box to
> see if it's got bad memory?

Yes. I have run memtest for one week:
no errors.
I have also changed the mother board,
scsi controller and ram. Only the cpu
and the 2 hot swap scsi disks were
not replaced. IMHO this isn't an
hardware problem, because the kernel
with debugging options enabled didn't
crash for a long time (>1 month). Just
for record, at this moment this box is
running 2.6.22-rc4 with no debug
options enabled. I will keep you
informed.
Thanks everybody for the support.


