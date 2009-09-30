Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbZI3MVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbZI3MVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbZI3MVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:21:52 -0400
Received: from khc.piap.pl ([195.187.100.11]:53025 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbZI3MVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:21:52 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Lennart Baruschka" <FunFlyer@gmx.net>, linux-kernel@vger.kernel.org
Subject: Re: Disabling DMA with ICH10?
References: <1254173481.4454.32.camel@goodbyte.homelinux.com>
	<20090928234025.6dc4e3f7@lxorguk.ukuu.org.uk>
	<20090929075416.77960@gmx.net> <20090929101114.1712314b@infradead.org>
	<m3bpku3peg.fsf@intrepid.localdomain>
	<20090929180555.3c4a7259@lxorguk.ukuu.org.uk>
	<m3k4zh32vp.fsf@intrepid.localdomain>
	<20090929233505.7ff11cad@lxorguk.ukuu.org.uk>
Date: Wed, 30 Sep 2009 14:21:53 +0200
In-Reply-To: <20090929233505.7ff11cad@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Tue, 29 Sep 2009 23:35:05 +0100")
Message-ID: <m3hbukfwri.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> INB foo
>
> 	CPU -> PCI device		read this register
> 	PCI device -> Disk
> 			trundle whirr whirrr
> 			clunk clunk thud
> 	Disk -> PCI device
> 	PCI device -> CPU... "5"
>
> INB completes
>
> The INB is not interruptible mid instruction and stalls the CPU for the
> full period of the message passing back and forth across the bus. So PIO
> 0 on PCI stalls the bus for the equivalent of an ISA access, and PIO4
> while a good deal faster is still a very long stall in hard real time
> terms.

Sure :-)

That's why I wrote it's a bad idea. I just wanted to correct the
statement about ISA speed - it's not (necessarily) ISA speed, though
it's slow and uses 100% CPU (core) time. (And PIO on PCI* in general
is not much faster, though usually faster than ISA).
-- 
Krzysztof Halasa
