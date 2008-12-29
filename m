Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbYL2Vfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbYL2Vfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 16:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbYL2Vf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 16:35:26 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60153 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753851AbYL2VfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:35:24 -0500
Subject: Re: linux-next: Tree for December 29 (fcoe)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081229123115.9a255fa8.randy.dunlap@oracle.com>
References: <20081230031621.60acd90b.sfr@canb.auug.org.au>
	 <20081229123115.9a255fa8.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Mon, 29 Dec 2008 15:35:20 -0600
Message-Id: <1230586520.3302.61.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-29 at 12:31 -0800, Randy Dunlap wrote:
> On Tue, 30 Dec 2008 03:16:21 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20081219:
> > 
> > Undropped tree:
> > 	scci
> > 	mtd
> > 
> > Dropped trees (temporarily):
> > 	nfs (akpm request due to 2.6.30 features)
> > 	kvm (build problem)
> > 	rr (build poblem)
> > 	semaphore-removal (due to unfixed conflicts against Linus' tree)
> > 	cpu_alloc (build problem)
> > 	audit (difficult conflicts)
> > 
> > Linus' tree had three build failures requiring patches and one requiring
> > a revert.
> 
> 
> linux-next-20081229/drivers/scsi/fcoe/libfcoe.c:995: error: dereferencing pointer to incomplete type
> linux-next-20081229/drivers/scsi/fcoe/libfcoe.c:1015: error: dereferencing pointer to incomplete type
> 
> (on netdev->name ?)

This looks a bit odd.  libfcoe.h #includes linux/netdevice.h which
defines the structure ... I can't see how netdev could have an
incomplete type.  Could you make libfcoe.i and see what's happening?

Thanks,

James


