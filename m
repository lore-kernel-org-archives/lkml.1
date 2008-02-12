Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbYBLVtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbYBLVtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbYBLVtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:49:12 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44842 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751142AbYBLVtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:49:10 -0500
Date: Tue, 12 Feb 2008 21:41:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: benh@kernel.crashing.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 00/18] ide: warm-plug support for IDE devices and other
 goodies
Message-ID: <20080212214137.47478e5e@core>
In-Reply-To: <1202850247.7410.24.camel@pasglop>
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
	<1202460043.7079.157.camel@pasglop>
	<1202850247.7410.24.camel@pasglop>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 08:04:07 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> 
> On Fri, 2008-02-08 at 19:40 +1100, Benjamin Herrenschmidt wrote:
> > On Fri, 2008-02-08 at 01:44 +0100, Bartlomiej Zolnierkiewicz wrote:
> > > - couple of fixes and preparatory patches
> > > 
> > > - rework of PowerMac media-bay support ([un]register IDE devices instead of
> > >   [un]registering IDE interface) [ it is the main reason for spamming PPC ML ]
> > 
> > Interesting... I was thinking about doing a full remove of the device at
> > a higher level instead but I suppose what you propose is easier.
> > 
> > I'll have a look & test next week hopefully.
> 
> Also, the above would have the advantage of not relying on drivers/ide
> infrastructure, and thus working with libata (once somebody has ported
> pmac ide to libata).

Unfortunately you need a degree in dentistry to open a Macintosh up and
fix it otherwise we would have support by now.

Alan
