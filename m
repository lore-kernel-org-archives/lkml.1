Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbYGWVSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbYGWVSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 17:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbYGWVSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 17:18:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41133 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753946AbYGWVSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:18:32 -0400
Date: Wed, 23 Jul 2008 22:01:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeroen Beerstra <jeroen@scorpion77.cjb.net>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: non functional pata dvd drive under 2.6.25.6
Message-ID: <20080723220107.3d26e30a@lxorguk.ukuu.org.uk>
In-Reply-To: <200807232219.47760.jeroen@scorpion77.cjb.net>
References: <vi85j5-uig.ln1@scorpion77.cjb.net>
	<4880237A.7070002@kernel.org>
	<200807232219.47760.jeroen@scorpion77.cjb.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2008 22:19:47 +0200
Jeroen Beerstra <jeroen@scorpion77.cjb.net> wrote:

> Hello Tejun,
> 
> Op Friday 18 July 2008 07:00:42 schreef u:
> > Hello, Jeroen.
> >
> > [cc'ing linux-ide]
> >
> > Hmmm... the problem could be caused by hald polling for media presence.
> >  Does "hal-disable-polling /dev/srX" make any difference?
> > hal-disable-polling setting is persistent so if your drive goes bonkers
> > quickly after boot, you can disable polling, reboot and see whether
> > anything is different.  Also, please post the result of "lspci -nn" and
> > "hdparm -I /dev/srX" && please try 2.6.26.
> >
> > Thanks.
> 
> I'm pretty sure about that since the hald process I'm refering to points to 
> the 'faulty' drive. However simply booting with noapic seems to fix all of my 
> problems.

There are lots of similar reports. I don't know what broke the APIC code
but it doesn't appear any of these are libata bugs.

Alan
