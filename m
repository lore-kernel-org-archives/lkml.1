Return-Path: <linux-kernel-owner+w=401wt.eu-S1752001AbYHIJvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbYHIJvO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 05:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbYHIJu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 05:50:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47593 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750931AbYHIJu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 05:50:57 -0400
Date: Sat, 9 Aug 2008 10:33:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Grant Coady <gcoady.lk@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] cleanup Serial ATA and Parallel ATA Kconfig
Message-ID: <20080809103331.1d475d5c@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.1.10.0808081911080.3254@localhost.localdomain>
References: <alpine.LFD.1.10.0808081228450.11491@localhost.localdomain>
	<20080808172629.232bed01@lxorguk.ukuu.org.uk>
	<njhp94pr4ha1nfgmj11n662enalpd9663h@4ax.com>
	<m3sktfw1v5.fsf@maximus.localdomain>
	<alpine.LFD.1.10.0808081911080.3254@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I would also ask for PATA and for SATA first:
> >
> > [*] PATA support
> > [*] SATA support
> 
>   that was sort my original thought, but i don't know enough about ATA
> fundamentals to know if it makes sense for these to be independently
> selectable. 

Alas it does not or we would have done so. A lot of the chips have things
like 'two SATA one PATA' and some of them have SATA and PATA variants of
the same chip. Then we have generic drivers like ata_generic which really
don't care if its SATA or PATA ..
