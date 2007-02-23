Return-Path: <linux-kernel-owner+w=401wt.eu-S1750837AbXBWDoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750837AbXBWDoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 22:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbXBWDoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 22:44:15 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:56451 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbXBWDoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 22:44:14 -0500
Date: Fri, 23 Feb 2007 04:42:43 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com,
       Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] dma-mapping-broken.h: flesh-out DMA API stubs
Message-ID: <20070223034243.GA7988@osiris.ibm.com>
References: <20070223005945.GA13084@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223005945.GA13084@tuxdriver.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 07:59:45PM -0500, John W. Linville wrote:
> This allows some drivers compile on arches that don't support DMA
> (e.g. s390).

Which drivers are we talking about? Last time I checked an allmodconfig
just compiled.
I'd rather like to the opposite: rip out everything that depends on DMA
(via e.g. CONFIG_HAS_DMA), so we don't have to compile in all the unused
code. If that is is possible...

-- 
Heiko Carstens
Linux on System z Development

IBM Deutschland Entwicklung GmbH
Vorsitzender des Aufsichtsrats: Johann Weihen
Geschaeftsfuehrung : Herbert Kircher
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
