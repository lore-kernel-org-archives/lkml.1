Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbYEZTw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbYEZTw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 15:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbYEZTwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 15:52:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:46716 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754846AbYEZTwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 15:52:11 -0400
Subject: Re: pci-gart_64.c: could we get better explanation?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20080526184703.GA17369@elf.ucw.cz>
References: <20080526184703.GA17369@elf.ucw.cz>
Content-Type: text/plain
Date: Tue, 27 May 2008 05:51:39 +1000
Message-Id: <1211831499.3286.2.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-26 at 20:47 +0200, Pavel Machek wrote:
> Hi!
> 
> +++ b/arch/x86/kernel/pci-gart_64.c
> @@ -774,6 +778,7 @@ #endif
>  
>         /*
>          * Try to workaround a bug (thanks to BenH)
>          * Set unmapped entries to a scratch page instead of 0.
>          * Any prefetches that hit unmapped entries won't get an bus abort
> 
> Could someone explain? Which bug is being worked around? CPUs
> prefetching over NULL?

P2P bridge prefetching on DMA reads.

Ben.


