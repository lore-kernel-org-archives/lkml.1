Return-Path: <linux-kernel-owner+w=401wt.eu-S1765607AbXHGBYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765607AbXHGBYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 21:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbXHGBYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 21:24:21 -0400
Received: from ns1.suse.de ([195.135.220.2]:48946 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbXHGBYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 21:24:20 -0400
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Robert Hancock <hancockr@shaw.ca>, linuxppc-dev@ozlabs.org,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       Olaf Hering <olh@suse.de>
Subject: Re: [PATCH 2.6.22.y] ieee1394: revert "sbp2: enforce 32bit	DMA	mapping"
References: <fa.Qn3Snqoik3hhnxcA6HqjGV0Yzck@ifi.uio.no>
	<46B4B3DC.7020609@shaw.ca> <46B4B7C6.1040107@s5r6.in-berlin.de>
	<1186272926.938.8.camel@localhost.localdomain>
	<46B5824B.1000103@s5r6.in-berlin.de>
	<1186351473.938.21.camel@localhost.localdomain>
	<20070806135124.GA2900@suse.de>
	<1186436848.938.75.camel@localhost.localdomain>
	<46B79F25.50205@s5r6.in-berlin.de> <46B79FD7.9020801@shaw.ca>
	<46B7A537.9020807@s5r6.in-berlin.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 07 Aug 2007 04:18:43 +0200
In-Reply-To: <46B7A537.9020807@s5r6.in-berlin.de>
Message-ID: <p73bqdkccjg.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter <stefanr@s5r6.in-berlin.de> writes:
> 
>   1.) The ieee1394 subsystem is known to work on x86_64 with more than 4
> GB RAM, 

It's actually ~3+GB where memory above the 4GB barrier starts appearing.
In some extreme cases even for 2+GB. 

> so I gather that architecture code already sets a proper DMA
> mask for all those 32bit PCI OHCI-1394 implementations out there.

If you don't set a DMA mask then the default is always 4GB.

-Andi
