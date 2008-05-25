Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbYEYWQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbYEYWQP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 18:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbYEYWQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 18:16:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52554 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751737AbYEYWQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 18:16:03 -0400
Date: Sun, 25 May 2008 23:02:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Miquel van Smoorenburg <miquels@cistron.nl>,
       Glauber Costa <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, andi-suse@firstfloor.org
Subject: Re: 2.6.26: x86/kernel/pci_dma.c: gfp |= __GFP_NORETRY ?
Message-ID: <20080525230216.1fe1b216@core>
In-Reply-To: <20080525212350.GB8405@one.firstfloor.org>
References: <20080521113028.GA24632@xs4all.net>
	<48341A57.1030505@redhat.com>
	<20080522084736.GC31727@one.firstfloor.org>
	<1211484343.30678.15.camel@localhost.localdomain>
	<1211657898.25661.2.camel@localhost.localdomain>
	<20080525163539.GA8405@one.firstfloor.org>
	<20080525205532.3ed5e478@core>
	<20080525212350.GB8405@one.firstfloor.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No it doesn't because the lower zone protection basically never puts
> anything that is not GFP_DMA into the 16MB zone.
> 
> Just check yourself on your machine using sysrq.
> 
> That was one of the motivations behind the mask allocator design.

Try a 16MB embedded PC 

Alan
