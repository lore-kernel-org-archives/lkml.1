Return-Path: <linux-kernel-owner+w=401wt.eu-S1762769AbYHEQ6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762769AbYHEQ6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762772AbYHEQ5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:57:13 -0400
Received: from ausxippc101.us.dell.com ([143.166.85.207]:60805 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762734AbYHEQ5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:57:11 -0400
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns;
  h=Date:From:To:Cc:Subject:Message-ID:References:
   Mime-Version:Content-Type:Content-Disposition:In-Reply-To:
   User-Agent;
  b=rG+4y7yv39b43I1UVFjtvIOitghImDMlnHpkYA62m2y/zTtZ8jZt8AWo
   CxPuGBEB2dLrs0UwO9SYydYMVvFNJjfexQzzxX2T24vP/hhZG9UE2702V
   q3c0FLZjNYkAIFW;
Date: Tue, 5 Aug 2008 11:57:10 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Jim Meyering <jim@meyering.net>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: tools support for non-512 byte sector sizes
Message-ID: <20080805165710.GA5648@auslistsprd01.us.dell.com>
References: <488F524F.6020905@redhat.com> <20080729182611.GB24924@parisc-linux.org> <1217356645.6103.48.camel@localhost.localdomain> <yq13alsr0g0.fsf@sermon.lab.mkp.net> <20080730135147.GA4513@auslistsprd01.us.dell.com> <20080801161149.GA26461@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801161149.GA26461@parisc-linux.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 10:11:49AM -0600, Matthew Wilcox wrote:
> On Wed, Jul 30, 2008 at 08:51:47AM -0500, Matt Domsch wrote:
> > I have access to disks with native 4KB sectors now too.  Would
> > interested parties be willing to share test plans, so we could be
> > sure we have coverage wrt correctness: kernel internals, userspace
> > tools like parted, fdisk, kpartx, apps using O_DIRECT)?
> > Benchmarking winds up being an NDA activity this early in the game
> > so I don't want the focus of any joint work to be benchmarks yet.
> 
> Are they SCSI?

yes (SAS).

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
