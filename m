Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbXGDQpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbXGDQpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 12:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757307AbXGDQon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 12:44:43 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:26473 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116AbXGDQoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 12:44:39 -0400
X-Greylist: delayed 3627 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jul 2007 12:44:38 EDT
Date: Wed, 4 Jul 2007 19:44:26 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Some NCQ numbers...
Message-ID: <20070704164426.GA8061@localdomain>
References: <468392CE.6010206@msgid.tls.msk.ru> <20070704154405.GA27166@localdomain> <468BC81F.7090102@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468BC81F.7090102@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2007 at 08:17:35PM +0400, Michael Tokarev wrote:
> Dan Aloni wrote:
> > On Thu, Jun 28, 2007 at 02:51:58PM +0400, Michael Tokarev wrote:
> >> [..]
> >> Test machine was using MPTSAS driver for the following card:
> >>   SCSI storage controller: LSI Logic / Symbios Logic SAS1064E PCI-Express Fusion-MPT SAS (rev 02)
> >>
> >> Pretty similar results were obtained on an AHCI controller:
> >>   SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) Serial ATA Storage Controller AHCI (rev 01)
> >> on another machines.
> > 
> > Are you sure that NCQ was enabled between the controller and drive? 
> > Did you verify this? I know about some versions that disable NCQ 
> > support internally in their firmware (something to do with bugs in
> > error handling).
> 
> The next obvious question is: how to check/verify this?

On the lowest level, it's possible using a protocol analyzer. If you 
don't have one, you need to be familiar with the controller's driver 
or its firmware. If the driver is based on libata, I think it's 
possible to get this information easier. Otherwise, such as in the 
case of mptsas, it can be completely hidden by the firmware.

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
