Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbXGGSdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbXGGSdu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 14:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbXGGSdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 14:33:42 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:22746 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbXGGSdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 14:33:42 -0400
Date: Sat, 7 Jul 2007 20:33:41 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Mark Lord <lkml@rtr.ca>
cc: Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>,
       linux-kernel@vger.kernel.org
Subject: Re: PATA-disk named sda
In-Reply-To: <468E8229.5040602@rtr.ca>
Message-ID: <Pine.LNX.4.64.0707072033060.1536@fbirervta.pbzchgretzou.qr>
References: <20070706102132.14fbc600.Christoph.Pleger@cs.uni-dortmund.de>
 <200707061413.53182.surenkarapetyan@gmail.com>
 <20070706113618.1d5e216a.Christoph.Pleger@cs.uni-dortmund.de>
 <468E8229.5040602@rtr.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 6 2007 13:55, Mark Lord wrote:
> Christoph Pleger wrote:
>> Hello,
>> 
>> > In recent kernels both PATA and SATA (SCSI too) drives are handled by
>> > libata  library. It calls all the drives sd* . 
>> 
>> If so, what about the use of hdparm then? I could not change parameters
>> like DMA, MultSectIO and 32-Bit support with hdparm. sdparm also did not
>> do that work.
>
> hdparm will still work for most functions,
> but setting dma, multsectio, and 32-bit are now solely
> the responsibility of the kernel (libata), for now.

Yeah. `smartctl -d ata -a /dev/sda` is also one to work :)



	Jan
-- 
