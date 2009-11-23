Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbZKWUsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbZKWUsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 15:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbZKWUsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 15:48:54 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51144 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753512AbZKWUsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 15:48:53 -0500
Date: Mon, 23 Nov 2009 20:32:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pata_hpt37x: add proper cable detection methods
Message-ID: <20091123203213.3ed4f7d4@lxorguk.ukuu.org.uk>
In-Reply-To: <4B0AE59F.7040202@ru.mvista.com>
References: <200911191910.44609.bzolnier@gmail.com>
	<4B0AE59F.7040202@ru.mvista.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009 22:42:23 +0300
Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:

> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  drivers/ata/pata_hpt37x.c |   86 +++++++++++++++++++++++++++++-----------------
> >  1 file changed, 56 insertions(+), 30 deletions(-)
> 
> > Index: b/drivers/ata/pata_hpt37x.c
> > ===================================================================
> > --- a/drivers/ata/pata_hpt37x.c
> > +++ b/drivers/ata/pata_hpt37x.c
> > @@ -303,6 +303,59 @@ static unsigned long hpt370a_filter(stru
> 
>     As this driver still carries a version info, don't we need to update it?

I don't think the version info is really useful any more - it was when
they were being developed but it has become a bit meaningless

