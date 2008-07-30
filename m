Return-Path: <linux-kernel-owner+w=401wt.eu-S1760851AbYG3NwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760851AbYG3NwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 09:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYG3Nvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 09:51:50 -0400
Received: from ausxipps301.us.dell.com ([143.166.148.223]:53479 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbYG3Nvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 09:51:49 -0400
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns;
  h=Date:From:To:Cc:Subject:Message-ID:References:
   Mime-Version:Content-Type:Content-Disposition:In-Reply-To:
   User-Agent;
  b=cfQ+qG5e/8u1PLXOv7apD2vMGUyBwPXLK8EJ6mEbfmn/mHbXfXD4GAK4
   IsXhyS4qgBaoUOZH2ACbvm3HAxK9bvADfZ1TxVsfDZW6Ckgl6EfGcmxVu
   gWSkkqj2Fz0XLND;
Date: Wed, 30 Jul 2008 08:51:47 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Wilcox <matthew@wil.cx>, Ric Wheeler <rwheeler@redhat.com>,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       Jim Meyering <jim@meyering.net>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: tools support for non-512 byte sector sizes
Message-ID: <20080730135147.GA4513@auslistsprd01.us.dell.com>
References: <488F524F.6020905@redhat.com> <20080729182611.GB24924@parisc-linux.org> <1217356645.6103.48.camel@localhost.localdomain> <yq13alsr0g0.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq13alsr0g0.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 02:48:31PM -0400, Martin K. Petersen wrote:
> >>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> James> The problem, which ata_ram also suffers, is that the tools we
> James> most need to test are the ones for manipulating non volatile
> James> characteristics (like partition tables).  We'd really like the
> James> disk contents to survive reboot for this ...
> 
> Yeah, I should add that I wanted persistence too.  I went through a
> whole stack (well, 5-6 or so) fibre channel drives from various
> vendors and attempted to low-level format them to 4KB sectors.  Most
> of them laughed in my face.  One of them tried to comply and
> irreparably confused its firmware in the process.
> 
> Just yesterday I received a couple of prototype drives in the mail.
> I'll ask the vendor whether they support 4KB and if so I'll give them
> a whirl.

I have access to disks with native 4KB sectors now too.  Would
interested parties be willing to share test plans, so we could be sure
we have coverage wrt correctness: kernel internals, userspace tools like parted,
fdisk, kpartx, apps using O_DIRECT)?  Benchmarking winds up being an
NDA activity this early in the game so I don't want the focus of any
joint work to be benchmarks yet.

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
