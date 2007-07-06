Return-Path: <linux-kernel-owner+w=401wt.eu-S1764401AbXGFR4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764401AbXGFR4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761795AbXGFRz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:55:56 -0400
Received: from rtr.ca ([64.26.128.89]:4043 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757809AbXGFRzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:55:55 -0400
Message-ID: <468E8229.5040602@rtr.ca>
Date: Fri, 06 Jul 2007 13:55:53 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PATA-disk named sda
References: <20070706102132.14fbc600.Christoph.Pleger@cs.uni-dortmund.de>	<200707061413.53182.surenkarapetyan@gmail.com> <20070706113618.1d5e216a.Christoph.Pleger@cs.uni-dortmund.de>
In-Reply-To: <20070706113618.1d5e216a.Christoph.Pleger@cs.uni-dortmund.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Pleger wrote:
> Hello,
> 
>> In recent kernels both PATA and SATA (SCSI too) drives are handled by
>> libata  library. It calls all the drives sd* . 
> 
> If so, what about the use of hdparm then? I could not change parameters
> like DMA, MultSectIO and 32-Bit support with hdparm. sdparm also did not
> do that work.

hdparm will still work for most functions,
but setting dma, multsectio, and 32-bit are now solely
the responsibility of the kernel (libata), for now.

Cheers
