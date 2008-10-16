Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbYJPVVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbYJPVVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 17:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbYJPVVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 17:21:24 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:35043 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbYJPVVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 17:21:23 -0400
Date: Thu, 16 Oct 2008 15:21:22 -0600
From: Alex Chiang <achiang@hp.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, jeff@redhat.com, linux-ide@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] stop gcc warning about uninitialized 'dev' in
	ata_scsi_scan_host
Message-ID: <20081016212122.GA18274@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Adrian Bunk <bunk@kernel.org>, Tejun Heo <tj@kernel.org>,
	jeff@redhat.com, linux-ide@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20081015232505.GB9272@ldl.fc.hp.com> <48F6A2E7.5090005@kernel.org> <20081016034042.GA27621@ldl.fc.hp.com> <20081016061638.GA23630@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016061638.GA23630@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk <bunk@kernel.org>:
> On Wed, Oct 15, 2008 at 09:40:42PM -0600, Alex Chiang wrote:
> > * Tejun Heo <tj@kernel.org>:
> > > Alex Chiang wrote:
> > > > Shuts up gcc-3.4.5-glibc-2.3.6 when it complains of:
> > > > 
> > > > drivers/ata/libata-scsi.c: In function `ata_scsi_scan_host':
> > > > drivers/ata/libata-scsi.c:3225: warning: 'dev' might be used
> > > > uninitialized in this function
> > > > 
> > > > Signed-off-by: Alex Chiang <achiang@hp.com>
> > > 
> > > Nacked-by: Tejun Heo <tj@kernel.org>
> > > 
> > > Some gcc versions complain about sata_via, others complain
> > > about something else.  Some versions complain about some
> > > iterator usages while not complaining about others, but none of
> > > those complaints is actually wrong or dangerous.  I don't think
> > > adding = NULL whenever some version of gcc complains is the
> > > right approach.
> > 
> > Hm, ok.
> > 
> > I guess we don't want to sprinkle these around all over the place
> > just to solve cosmetic issues, which makes sense, but is there
> > some other approach we could take instead? Any suggestions? Or
> > just live with it?
> 
> We have an annotation for these kinds of warnings in the kernel.

What is the annotation?

> But we'll never get a warning-free compilation with all seven (sic) 
> supported gcc release series.
> 
> A warning-free compilation with gcc 4.3 is worth some efforts, but 
> cluttering our code to fix bogus warnings with older gcc versions
> is not a good thing.

Ok, I already agree with this point.

Thanks.

/ac

