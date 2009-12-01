Return-Path: <linux-kernel-owner+w=401wt.eu-S1753070AbZLAOGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbZLAOGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 09:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZLAOGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 09:06:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38477 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbZLAOGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 09:06:06 -0500
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.32-rc8
From: James Bottomley <James.Bottomley@suse.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kai Makisara <Kai.Makisara@kolumbus.fi>
In-Reply-To: <20091201080346W.fujita.tomonori@lab.ntt.co.jp>
References: <1259620194.11762.137.camel@mulgrave.site>
	 <20091201080346W.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 09:06:06 -0500
Message-Id: <1259676366.11762.239.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-01 at 08:03 +0900, FUJITA Tomonori wrote:
> On Mon, 30 Nov 2009 17:29:54 -0500
> James Bottomley <James.Bottomley@suse.de> wrote:
> 
> > This is a set of miscellaneous (but small) fixes for SCSI.
> > 
> > The patch is available here:
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> > 
> > The short changelog is:
> > 
> > Alexey Kuznetsov (1):
> >       fix crash when disconnecting usb storage
> > 
> > James Bottomley (1):
> >       fix async scan add/remove race resulting in an oops
> > 
> > Martin K. Petersen (1):
> >       sd: Return correct error code for DIF
> > 
> > The diffstat is:
> > 
> >  drivers/scsi/hosts.c       |    2 -
> >  drivers/scsi/scsi_scan.c   |   18 ++----------
> >  drivers/scsi/scsi_sysfs.c  |   63 +++++++++++++++++++--------------------------
> >  drivers/scsi/sd_dif.c      |    2 -
> >  include/scsi/scsi_device.h |    1 
> >  5 files changed, 34 insertions(+), 52 deletions(-)
> 
> Can you add the tape driver fix?

Sure ... can I have an acked-by from Kai?

Thanks,

James


