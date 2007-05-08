Return-Path: <linux-kernel-owner+w=401wt.eu-S967066AbXEHRu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967066AbXEHRu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 13:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966751AbXEHRuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 13:50:25 -0400
Received: from [81.2.110.250] ([81.2.110.250]:43167 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S966405AbXEHRuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 13:50:24 -0400
Date: Tue, 8 May 2007 18:53:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Fix old SCSI adapter crashes with CD-ROM (take 2)
Message-ID: <20070508185359.01a1a18d@the-village.bc.nu>
In-Reply-To: <1178646426.3737.59.camel@mulgrave.il.steeleye.com>
References: <20070508171710.1ac730cd@the-village.bc.nu>
	<20070508161444.GA4163@kernel.dk>
	<1178642376.3737.36.camel@mulgrave.il.steeleye.com>
	<20070508184256.029cf8a4@the-village.bc.nu>
	<1178646426.3737.59.camel@mulgrave.il.steeleye.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Long answer - it doesn't take this path.
> > 
> > Different bug, both want fixing I suspect.
> 
> Actually, it does take this path ... one of the things we've been doing
> in SCSI is slowly eliminating the old direct submission paths in favour
> of sending everything through the correct block layer paths.
> scsi_execute(), which the sr ioctl uses is just such a fixed path ...
> the bug is that it should be bouncing the request but because of an
> oversight (which Mike's patch corrects) it doesn't.

Well if Mike's patch is going in and it fixes this then I'll be more than
happy to withdraw the pending one.

> 
> The ultimate goal is to be able to eliminate the unchecked_isa_dma flag
> entirely and have the block layer (or device mask allocations) fix all
> of this in every ULD.

About time ;)


Alan
