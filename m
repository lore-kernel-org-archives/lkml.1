Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbZDNL7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbZDNL7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 07:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbZDNL7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 07:59:23 -0400
Received: from tamago.serverit.net ([91.189.209.155]:57395 "EHLO
	mail.hosting2.serverit.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755330AbZDNL7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 07:59:21 -0400
Date: Tue, 14 Apr 2009 14:58:11 +0300 (EEST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.com>
X-X-Sender: szaka@tamago.serverit.net
To: Jeff Garzik <jeff@garzik.org>
cc: Avi Kivity <avi@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
In-Reply-To: <49E47744.3040103@garzik.org>
Message-ID: <Pine.LNX.4.62.0904141447520.13379@tamago.serverit.net>
References: <20090412091228.GA29937@elte.hu> <Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net>
 <20090412162018.6c1507b4@lxorguk.ukuu.org.uk> <49E213AE.4060506@redhat.com>
 <alpine.LFD.2.00.0904120950050.4583@localhost.localdomain> <49E2DC96.6090407@redhat.com>
 <alpine.LFD.2.00.0904130747440.4583@localhost.localdomain> <49E45E9C.1020105@redhat.com>
 <49E46437.5000804@garzik.org> <49E46779.1040106@redhat.com>
 <49E47744.3040103@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 14 Apr 2009, Jeff Garzik wrote:
> Avi Kivity wrote:
> > Jeff Garzik wrote:
> > > Speaking of RMW...    in one sense, we have to deal with RMW anyway.
> > > Upcoming ATA hard drives will be configured with a normal 512b sector API
> > > interface, but underlying physical sector size is 1k or 4k.
> > > 
> > > The disk performs the RMW for us, but we must be aware of physical sector
> > > size in order to determine proper alignment of on-disk data, to minimize
> > > RMW cycles.
> > > 
> > 
> > Virtualization has the same issue.  OS installers will typically setup the
> > first partition at sector 63, and that means every page-sized block access
> > will be misaligned.  Particularly bad when the guest's disk is backed on a
> > regular file.
> > 
> > Windows 2008 aligns partitions on a 1MB boundary, IIRC.
> 
> Makes a lot of sense...

Since Vista at least the first partition is 2048 sector aligned.

	Szaka

--
NTFS-3G: http://ntfs-3g.org
