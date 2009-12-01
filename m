Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbZLASXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbZLASXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 13:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbZLASXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 13:23:24 -0500
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:38210 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbZLASXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 13:23:24 -0500
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Dec 2009 13:23:24 EST
Date: Tue, 1 Dec 2009 20:14:39 +0200 (EET)
From: Kai Makisara <Kai.Makisara@kolumbus.fi>
X-X-Sender: makisara@kai.makisara.local
To: James Bottomley <James.Bottomley@suse.de>
cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.32-rc8
In-Reply-To: <1259676366.11762.239.camel@mulgrave.site>
Message-ID: <alpine.LNX.2.00.0912012011190.21616@kai.makisara.local>
References: <1259620194.11762.137.camel@mulgrave.site>  <20091201080346W.fujita.tomonori@lab.ntt.co.jp> <1259676366.11762.239.camel@mulgrave.site>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009, James Bottomley wrote:

> On Tue, 2009-12-01 at 08:03 +0900, FUJITA Tomonori wrote:
> > On Mon, 30 Nov 2009 17:29:54 -0500
> > James Bottomley <James.Bottomley@suse.de> wrote:
> > 
> > > This is a set of miscellaneous (but small) fixes for SCSI.
> > > 
> > > The patch is available here:
> > > 
> > > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> > > 
> > > The short changelog is:
> > > 
> > > Alexey Kuznetsov (1):
> > >       fix crash when disconnecting usb storage
> > > 
> > > James Bottomley (1):
> > >       fix async scan add/remove race resulting in an oops
> > > 
> > > Martin K. Petersen (1):
> > >       sd: Return correct error code for DIF
> > > 
> > > The diffstat is:
> > > 
> > >  drivers/scsi/hosts.c       |    2 -
> > >  drivers/scsi/scsi_scan.c   |   18 ++----------
> > >  drivers/scsi/scsi_sysfs.c  |   63 +++++++++++++++++++--------------------------
> > >  drivers/scsi/sd_dif.c      |    2 -
> > >  include/scsi/scsi_device.h |    1 
> > >  5 files changed, 34 insertions(+), 52 deletions(-)
> > 
> > Can you add the tape driver fix?
> 
> Sure ... can I have an acked-by from Kai?
> 
There was already tested-by but here is

Acked-by: Kai Makisara <kai.makisara@kolumbus.fi>

Thanks,
Kai

