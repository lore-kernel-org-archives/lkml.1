Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbYHDOcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbYHDOcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbYHDOby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:31:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55894 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753407AbYHDObx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:31:53 -0400
Date: Mon, 4 Aug 2008 15:13:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Tejun Heo <htejun@gmail.com>, Elias Oltmanns <eo@nebensachen.de>,
       Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] libata: Implement disk shock protection support
Message-ID: <20080804151333.606eaaaf@lxorguk.ukuu.org.uk>
In-Reply-To: <20080804142831.GW8749@boogie.lpds.sztaki.hu>
References: <87prp1kvyy.fsf@denkblock.local>
	<20080726062142.29070.10413.stgit@denkblock.local>
	<4892B8FE.1070400@gmail.com>
	<20080804142831.GW8749@boogie.lpds.sztaki.hu>
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

On Mon, 4 Aug 2008 16:28:32 +0200
Gabor Gombas <gombasg@sztaki.hu> wrote:

> On Fri, Aug 01, 2008 at 04:19:26PM +0900, Tejun Heo wrote:
> 
> > However, SATA or not, there simply isn't a way to abort commands in ATA.
> >  Issuing random command while other commands are in progress simply is
> > state machine violation and there will be many interesting results
> > including complete system lockup (ATA controller dying while holding the
> > PCI bus).
> 
> A system lockup may be an acceptable compromise if that saves the
> hardware. Maybe the kernel should explicitely panic unless the
> controller/drive is known to be able to recover.

We've already been told that the accelerometer will now and then randomly
trigger due to other shock patterns like a bump. I don't want my laptop
to panic randomly on train journeys thank you.

Alan
