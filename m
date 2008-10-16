Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbYJPKTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbYJPKTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 06:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbYJPKTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 06:19:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44983 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751322AbYJPKTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 06:19:04 -0400
Date: Thu, 16 Oct 2008 11:18:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide: remove broken hpt34x driver
Message-ID: <20081016111851.4f519c58@lxorguk.ukuu.org.uk>
In-Reply-To: <48F70DDA.4010805@ru.mvista.com>
References: <200810152156.25754.bzolnier@gmail.com>
	<48F70DDA.4010805@ru.mvista.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 13:48:10 +0400
Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:

> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> > No big loss since HPT343/363 controllers are properly supported
> > by pata_hpt3x3 driver from Alan Cox.
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >   
> 
>    Hum, interesting way of fixing the driver... :-)
>    Shouldn't the PCI IDs be added to drivers/ide/pci/generic.c?

Won't work. The device isn't actually generic IDE. You have to sort the
register mappings out and use the right mapping window for the chip to
work.
