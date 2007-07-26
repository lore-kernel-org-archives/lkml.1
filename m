Return-Path: <linux-kernel-owner+w=401wt.eu-S933170AbXGZILf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170AbXGZILf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 04:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760355AbXGZIKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 04:10:52 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43885 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428AbXGZIKl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 04:10:41 -0400
Date: Thu, 26 Jul 2007 10:08:03 +0200
From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue@bull.net>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, ambx1@neo.rr.com,
       akpm@linux-foundation.org, lenb@kernel.org, rmk@arm.linux.org.uk,
       mjg59@srcf.ucam.org, castet.matthieu@free.fr, shaohua.li@intel.com,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to
 platform devices - broke my serial console
Message-ID: <20070726100803.31aeacc5@frecb000686.frec.bull.fr>
In-Reply-To: <200707251641.23406.bjorn.helgaas@hp.com>
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr>
	<200707250716.44609.bjorn.helgaas@hp.com>
	<20070725153253.4d7e7e37@frecb000686.frec.bull.fr>
	<200707251641.23406.bjorn.helgaas@hp.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 26/07/2007 10:15:20,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 26/07/2007 10:15:21,
	Serialize complete at 26/07/2007 10:15:21
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Jul 2007 16:41:23 -0600 Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> On Wednesday 25 July 2007 07:32:53 am Sébastien Dugué wrote:
> > On Wed, 25 Jul 2007 07:16:44 -0600 Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > 
> > > The _DDN is a "DOS device name", and the _UID is a "logical device ID
> > > that does not change across reboots."  Both are optional, and PNPACPI
> > > ignores them.  But maybe we could change PNPACPI to sort by them if
> > > they are present.  I'll think about this a bit.
> > 
> >   That would be nice, but I wish you good luck with all those
> > crappy BIOSes out there.
> 
> Yeah, it's an ugly world we live in.  Would you be able to try the
> attached patch just for testing?  It should sort devices with the
> same _HID by their _UID.  It doesn't have any effect on my systems,
> because my devices are already ordered by _UID by default.  But I
> think it should switch your COM1/COM2 ports back to the order you
> expect.
> 

  Works well, thanks Bjorn.

  Sébastien.
