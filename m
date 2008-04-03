Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbYDGUyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbYDGUyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 16:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYDGUx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 16:53:59 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46918 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750960AbYDGUx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 16:53:58 -0400
Date: Thu, 3 Apr 2008 18:50:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Frans Pop <elendil@planet.nl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Message-ID: <20080403185034.759022ce@the-village.bc.nu>
In-Reply-To: <200804022235.01433.linux@rainbow-software.org>
References: <200804021524.27222.elendil@planet.nl>
	<200804022210.26736.linux@rainbow-software.org>
	<20080402202225.GJ24237@csclub.uwaterloo.ca>
	<200804022235.01433.linux@rainbow-software.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008 22:34:58 +0200
Ondrej Zary <linux@rainbow-software.org> wrote:

> On Wednesday 02 April 2008 22:22:25 Lennart Sorensen wrote:
> > On Wed, Apr 02, 2008 at 10:10:23PM +0200, Ondrej Zary wrote:
> > > I mean S320BIDE.EXE - that's for this machine only.
> >
> > Hmm, I missed that one.  I wonder how they do it.  Well ISA did support
> > bus mastering DMA although it seems rare to implement it.  Or it could
> > be VLB style.
> 
> I suspect that the IDE controller is integrated into the Toshiba chipset but 
> does not appear as a separate PCI device. It could be controlled by some 
> registers of the "host-bridge" or some other device.

Toshiba Piccolo series. PCI chipset integrated IDE, not supported as
Toshiba refused to even answer emails about it. If you want it to work
you need to find out what registers their driver writes to

Alan
