Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbXJETOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbXJETOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759460AbXJETNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:13:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:58319 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759316AbXJETNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:13:43 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Mike Robak" <mrobak@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: libATA error message doc
References: <2b40bfd30710031039y70252a8bk898b102c993a92af@mail.gmail.com>
	<20071003192453.0ed967f1@the-village.bc.nu>
From: Andi Kleen <andi@firstfloor.org>
Date: 05 Oct 2007 21:13:39 +0200
In-Reply-To: <20071003192453.0ed967f1@the-village.bc.nu>
Message-ID: <p737im15q8s.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> > (irq_stat 0x40000001)	
> 
> 	IRQ status of the chip
> > tag 0
> 	Tag (or zero for non NCQ commands)
> > cmd 0xb0
> 	The ATA command number issued
> > emask 0x1
> 	Internal libata error category (used to decide what to do to
> recover)
> > stat 0x51
> 	Status register of drive
> > err 0x4
> 	Error register of drive
> 
> 
> You want the ATA specification document from T13 (www.t13.org)

The ISDN driver documentation always listed the numbers in the kernel documentation
even though people in theory could have gotten it from the specification too.

I always found that quite convenient. Putting at least a summary in Documentation
would probably user-friendly. It tends to be hard to find stuff in specifications,
especially if you're not very familiar with the standard.

-Andi
