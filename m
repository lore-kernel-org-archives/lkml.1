Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbYFQOGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbYFQOGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 10:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757535AbYFQOGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 10:06:44 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:55739 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbYFQOGn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 10:06:43 -0400
Date: Tue, 17 Jun 2008 16:06:28 +0200
From: Maxim Shchetynin <maxim@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Cc: =?UTF-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Jan Engelhardt <jengelh@medozas.de>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org
Subject: Re: AZFS file system proposal
Message-ID: <20080617160628.79efd2d9@mercedes-benz.boeblingen.de.ibm.com>
In-Reply-To: <20080617105300.GA28310@logfs.org>
References: <20080609104650.4f220492@mercedes-benz.boeblingen.de.ibm.com>
	<20080609125530.GF30405@parisc-linux.org>
	<20080610104919.504b9826@mercedes-benz.boeblingen.de.ibm.com>
	<alpine.LNX.1.10.0806110000560.20733@fbirervta.pbzchgretzou.qr>
	<20080617110655.59c915da@mercedes-benz.boeblingen.de.ibm.com>
	<alpine.LNX.1.10.0806171133220.6620@fbirervta.pbzchgretzou.qr>
	<20080617105300.GA28310@logfs.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2008 12:53:00 +0200
Jörn Engel <joern@logfs.org> wrote:

> On Tue, 17 June 2008 11:35:10 +0200, Jan Engelhardt wrote:
> > On Tuesday 2008-06-17 11:06, Maxim Shchetynin wrote:
> > 
> > >I would say you can either mmap it or place a file system on it.
> > 
> > The help text implies that I *need* azfs to mmap it - and that sounds
> > like a Rube Goldberg machine.
> 
> Some people actually prefer filesystems over raw devices for a variety
> of reasons:
> - each file brings its own address space, which offers memory protection
>   from other processes,
> - files can have owners and permission bits,
> - files hide the fragmentation of the underlying device from users,
> - a file system provides a common and well-understood api for devices
>   with less common or well-understood apis,
> - etc.
> 
> Those reasons are as valid for azfs as for any other filesystem.  I have
> no doubt that azfs is useful.  It probably wouldn't hurt to express the
> merits of the filesystem and the problems it is supposed to solve a
> little better.  So far most criticism was based on the fact that noone
> understood what the hell it was all about.
> 
> My personal question when looking at this is: Why not use ext2?  It

Same reason we don't use ext2 for file system in RAM - we don't need any expensive caching and readahead mechanisms for devices which are as fast as main memory (or almost as fast).

> appears to me that an ext2 mounted with '-o xip' would solve the same
> problems.

-- 
Mit freundlichen Grüßen / met vriendelijke groeten / avec regards

    Maxim V. Shchetynin
    Linux Kernel Entwicklung
    IBM Deutschland Entwicklung GmbH
    Linux für Cell, Abteilung 3250
    Schönaicher Straße 220
    71032 Böblingen

Vorsitzender des Aufsichtsrats: Johann Weihen
Geschäftsführung: Herbert Kircher
Sitz der Gesellschaft: Böblingen
Registriergericht: Amtsgericht Stuttgart, HRB 243294

Fahr nur so schnell wie dein Schutzengel fliegen kann!
