Return-Path: <linux-kernel-owner+w=401wt.eu-S967345AbXEHR6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967345AbXEHR6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 13:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967247AbXEHR6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 13:58:51 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:54642 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967047AbXEHR6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 13:58:49 -0400
Subject: Re: [PATCH]: Fix old SCSI adapter crashes with CD-ROM (take 2)
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org,
       akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070508185359.01a1a18d@the-village.bc.nu>
References: <20070508171710.1ac730cd@the-village.bc.nu>
	 <20070508161444.GA4163@kernel.dk>
	 <1178642376.3737.36.camel@mulgrave.il.steeleye.com>
	 <20070508184256.029cf8a4@the-village.bc.nu>
	 <1178646426.3737.59.camel@mulgrave.il.steeleye.com>
	 <20070508185359.01a1a18d@the-village.bc.nu>
Content-Type: text/plain
Date: Tue, 08 May 2007 12:58:35 -0500
Message-Id: <1178647115.3737.62.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 18:53 +0100, Alan Cox wrote:
> > The ultimate goal is to be able to eliminate the unchecked_isa_dma flag
> > entirely and have the block layer (or device mask allocations) fix all
> > of this in every ULD.
> 
> About time ;)

Actually, I should point out (before those who did the work get
justifiably irritated) that the overall goal is to remove the special
case non-scatter/gather path from all the drivers ... eliminating the
need to worry about DMA zone allocations is just a nice bonus as a side
effect of sending everything through the block layer.

James


