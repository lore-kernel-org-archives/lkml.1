Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbYDXMKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbYDXMKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 08:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYDXMJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 08:09:53 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44854 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752063AbYDXMJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 08:09:52 -0400
Date: Thu, 24 Apr 2008 12:35:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Jeff Garzik <jeff@garzik.org>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [2.6 patch] select ATA_SFF
Message-ID: <20080424123541.09e5ef96@the-village.bc.nu>
In-Reply-To: <480DEB1F.5060500@gmail.com>
References: <20080421213147.GH2633@cs181133002.pp.htv.fi>
	<480DE3C4.5@ru.mvista.com>
	<480DE6F5.8060403@gmail.com>
	<480DE9E8.2070809@ru.mvista.com>
	<480DEB1F.5060500@gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2008 22:41:51 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Sergei Shtylyov wrote:
> >>>    Jeff, Tejun, what "sff" in the file name actually means? Isn't it 
> >>> strange that the drivers lacking DMA support or not really compliant 
> >>> with SFF-8038i have to link with this file?
> > 
> >> Maybe it should be libata-tf and libata-bmdma, but sff (sans bmdma)
> >> and bmdma is acceptable, hopefully, right?
> > 
> >    What's sff sans bmdma?
> 
> Supposed to be TF interface.  IIRC, the SFF term was first from Alan 
> although it's entirely possible that I misunderstood it and used it in 
> the wrong way.  Alan, can you please clear up the confusion?

The SFF/Intel spec is for PCI IDE (BMDMA or otherwise), so it covers and
defines all the common bits of the IDE interface on PCI (and in defining
the legacy interface conveniently documents the extended ST-412 interface
used by ATA and "pre-ATA" IDE/EIDE controllers).

Alan
