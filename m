Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbYG3Pjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbYG3Pjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 11:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbYG3Pjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 11:39:43 -0400
Received: from web83206.mail.mud.yahoo.com ([216.252.101.62]:38434 "HELO
	web83206.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751986AbYG3Pjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 11:39:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=bv32D3hnNs8MqlMCXo5kxolDJTt58/ifr0CZ7ZJj6m2YgfVXum7lzPW6X0kiD0QzOaE/CjFneyFQsgApy/+gfa+mV2/ieaFGwbYrbDAU1hfmST38i6mQbw+E6f3Ytfhg8vdxEXHSqc+DwSDjjGDEPeKr7FRn9ISnjn0tzja2qM4=;
X-YMail-OSG: CXPEBr0VM1lqvqZg8G_q3jKwL.58BiKh5fNgMlIS21AkZOo5BXopJP8RAPrQ9jUZyLFhhkgtOEmsaOZr.ViU_QEzp366wQmsx87Gp2tF27NIC7cbHOkFYFk-
Date: Wed, 30 Jul 2008 08:39:42 -0700 (PDT)
From: Matthew Frost <artusemrys@yahoo.com>
Subject: Re: BUG: SCSI: usb storage SDHC card doesn't work in 2.6.27-rc1
To: Alan Stern <stern@rowland.harvard.edu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, Matt Frost <artusemrys@sbcglobal.net>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>
In-Reply-To: <Pine.LNX.4.44L0.0807301014420.2584-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <749062.6878.qm@web83206.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Alan Stern <stern@rowland.harvard.edu> wrote:

> On Tue, 29 Jul 2008, James Bottomley wrote:
> 
> > > Summary:
> > > Between 2.6.26-rc9-git10 and rc9-git11, the kernel stopped properly
> > > recognizing my USB-card-reader-mounted SDHC 4GB card.  The problem
> seems to
> > > come up between usb-storage recognizing the device, and the handoff to
> scsi
> > > to read the disk properties.  The bug remains in 2.6.26 and 2.6.27-rc1;
> > > kernels before 2.6.26-rc9-git10 are unaffected.  On the same EHCI
> controller,
> > > an old-spec SD 1GB card and its reader are unaffected by this bug.
> 
> > > After the bug, initialization looks the same until the device scan
> finishes. 
> > > Handoff to scsi produces the following (taken from rc9-git12):
> 
> > > sd 5:0:0:0: [sdf] Sector size 0 reported, assuming 512.
> > > sd 5:0:0:0: [sdf] 1 512-byte hardware sectors (0 MB)
> > > sd 5:0:0:0: [sdf] Write Protect is off
> > > sd 5:0:0:0: [sdf] Mode Sense: 4b 00 00 08
> > > sd 5:0:0:0: [sdf] Assuming drive cache: write through
> > > sd 5:0:0:0: [sdf] Sector size 0 reported, assuming 512.
> > > sd 5:0:0:0: [sdf] 1 512-byte hardware sectors (0 MB)
> > > sd 5:0:0:0: [sdf] Write Protect is off
> > > sd 5:0:0:0: [sdf] Mode Sense: 4b 00 00 08
> > > sd 5:0:0:0: [sdf] Assuming drive cache: write through
> > >  sdf: sdf1
> > >  sdf: p1 exceeds device capacity
> > > sd 5:0:0:0: [sdf] Attached SCSI removable disk
> > > sd 5:0:0:0: Attached scsi generic sg7 type 0
> 
> The problem will most likely be fixed by this patch:
> 
> 	http://marc.info/?l=linux-usb&m=121734710306509&w=2
> 
> Alan Stern
> 
> 

Thanks.  Giving it a try now.

Matt Frost
