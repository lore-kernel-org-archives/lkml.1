Return-Path: <linux-kernel-owner+w=401wt.eu-S1764344AbXGFR6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764344AbXGFR6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760619AbXGFR6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:58:34 -0400
Received: from rtr.ca ([64.26.128.89]:3125 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759236AbXGFR6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:58:34 -0400
Message-ID: <468E82C8.7060204@rtr.ca>
Date: Fri, 06 Jul 2007 13:58:32 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
Cc: Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>,
       linux-kernel@vger.kernel.org
Subject: Re: PATA-disk named sda
References: <fa.VMMtK2yPXE5gkxuIC8MWb1aPBiQ@ifi.uio.no> <fa.23lYEA4r0kfTVDJ1AKcxSE4vGKA@ifi.uio.no> <fa.DRDWDh+VAXx84D/6XHgY6h2wB+E@ifi.uio.no> <468E5420.7090605@shaw.ca>
In-Reply-To: <468E5420.7090605@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
>..
> Currently the DMA, multi-sector mode, etc. are not controllable with 
> hdparm with libata. libata is designed to use the fastest settings 
> possible by default. In a lot of cases this messing with hdparm was only 
> needed because of stupidity with the old IDE code (like DMA not being 
> automatically enabled if the low-level driver was built modular).

Actually, most of the hdparm flags were put there to help test the IDE
subsystem and to help debug the much stranger hardware it had to deal with.

"DMA off by default" was a Linus Torvalds request, to help ensure data safety
with all of the weird and wonderful crap pre-standardization.

Cheers

