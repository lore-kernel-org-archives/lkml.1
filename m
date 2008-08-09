Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbYHIKlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbYHIKlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 06:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbYHIKlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 06:41:12 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:38148 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbYHIKlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 06:41:11 -0400
Date: Sat, 9 Aug 2008 06:39:22 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Krzysztof Halasa <khc@pm.waw.pl>, Grant Coady <gcoady.lk@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] cleanup Serial ATA and Parallel ATA Kconfig
In-Reply-To: <20080809103331.1d475d5c@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.1.10.0808090637380.24602@localhost.localdomain>
References: <alpine.LFD.1.10.0808081228450.11491@localhost.localdomain> <20080808172629.232bed01@lxorguk.ukuu.org.uk> <njhp94pr4ha1nfgmj11n662enalpd9663h@4ax.com> <m3sktfw1v5.fsf@maximus.localdomain> <alpine.LFD.1.10.0808081911080.3254@localhost.localdomain>
 <20080809103331.1d475d5c@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Aug 2008, Alan Cox wrote:

> > I would also ask for PATA and for SATA first:
> > >
> > > [*] PATA support
> > > [*] SATA support
> >
> >   that was sort my original thought, but i don't know enough about ATA
> > fundamentals to know if it makes sense for these to be independently
> > selectable.
>
> Alas it does not or we would have done so. A lot of the chips have
> things like 'two SATA one PATA' and some of them have SATA and PATA
> variants of the same chip. Then we have generic drivers like
> ata_generic which really don't care if its SATA or PATA ..

at this point, i'll back away slowly and leave it for someone way
smarter than me to decide on.  at the very least, most of those
EXPERIMENTAL tags can be heaved over the side.

rday
--


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
