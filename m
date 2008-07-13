Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbYGMOZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbYGMOZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 10:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbYGMOZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 10:25:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56610 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753454AbYGMOZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 10:25:48 -0400
Date: Sun, 13 Jul 2008 15:08:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Alan Cox <alan@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: pata_it821x completely broken
Message-ID: <20080713150800.664ef076@lxorguk.ukuu.org.uk>
In-Reply-To: <200807131410.16521.linux@rainbow-software.org>
References: <200807042153.56644.linux@rainbow-software.org>
	<200807131347.14045.linux@rainbow-software.org>
	<20080713123510.6f47ffdc@lxorguk.ukuu.org.uk>
	<200807131410.16521.linux@rainbow-software.org>
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

On Sun, 13 Jul 2008 14:10:14 +0200
Ondrej Zary <linux@rainbow-software.org> wrote:

> On Sunday 13 July 2008 13:35:10 Alan Cox wrote:
> > > The patch below fixes the IDENTIFY problem for me and makes the RAID
> > > array accessible. Is it OK or is there a better way to do it?
> >
> > Probably better to fix it in driver. Right now we don't have a way to
> > override the identify reading or post process it cleanly at it821x hacks
> > around that but if that was fixed then the special cases can all hide in
> > the driver where they belong.
> 
> That would be great but it requires some deeper libata and kernel programming 
> knowledge.

Not a lot I think so I've added it to my todo list if nobody else does it.
