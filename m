Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbXGDPoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbXGDPoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 11:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbXGDPoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 11:44:12 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:23517 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbXGDPoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 11:44:11 -0400
Date: Wed, 4 Jul 2007 18:44:05 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Some NCQ numbers...
Message-ID: <20070704154405.GA27166@localdomain>
References: <468392CE.6010206@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468392CE.6010206@msgid.tls.msk.ru>
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

On Thu, Jun 28, 2007 at 02:51:58PM +0400, Michael Tokarev wrote:
>[..]
> Test machine was using MPTSAS driver for the following card:
>   SCSI storage controller: LSI Logic / Symbios Logic SAS1064E PCI-Express Fusion-MPT SAS (rev 02)
> 
> Pretty similar results were obtained on an AHCI controller:
>   SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) Serial ATA Storage Controller AHCI (rev 01)
> on another machines.

Are you sure that NCQ was enabled between the controller and drive? 
Did you verify this? I know about some versions that disable NCQ 
support internally in their firmware (something to do with bugs in
error handling).

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
