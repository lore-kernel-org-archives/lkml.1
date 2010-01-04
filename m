Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327Ab0ADXpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab0ADXpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 18:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297Ab0ADXoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:44:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:34829 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287Ab0ADXov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:44:51 -0500
Date: Mon, 4 Jan 2010 15:44:02 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linux-kernel@vger.kernel.org, kashyap.desai@lsi.com,
       James.Bottomley@suse.de, stable@kernel.org
Subject: Re: patch
 scsi-mpt2sas-add-missing-initialization-of-scsih_cmds.patch added to
 2.6.32-stable tree
Message-ID: <20100104234401.GA10770@suse.de>
References: <12626340131357@kroah.org>
 <201001042255.07139.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001042255.07139.s.L-H@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 10:55:02PM +0100, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Monday 04 January 2010, gregkh@suse.de wrote:
> > This is a note to let you know that we have just queued up the patch titled
> > 
> >     Subject: SCSI: mpt2sas: add missing initialization of scsih_cmds
> > 
> > to the 2.6.32-stable tree.  Its filename is
> > 
> >     scsi-mpt2sas-add-missing-initialization-of-scsih_cmds.patch
> 
> Adding this patch to 2.6.32 (and likely 2.6.31 as well) breaks building the
> current stable queue:
> 
>   LD      drivers/scsi/mpt2sas/built-in.o
>   CC [M]  drivers/scsi/mpt2sas/mpt2sas_base.o
> drivers/scsi/mpt2sas/mpt2sas_base.c: In function 'mpt2sas_base_attach':
> drivers/scsi/mpt2sas/mpt2sas_base.c:3500: error: 'struct MPT2SAS_ADAPTER' has no member named 'scsih_cmds'
> drivers/scsi/mpt2sas/mpt2sas_base.c:3501: error: 'struct MPT2SAS_ADAPTER' has no member named 'scsih_cmds'
> drivers/scsi/mpt2sas/mpt2sas_base.c:3502: error: 'struct MPT2SAS_ADAPTER' has no member named 'scsih_cmds'
> make[6]: *** [drivers/scsi/mpt2sas/mpt2sas_base.o] Error 1
> make[5]: *** [drivers/scsi/mpt2sas] Error 2

Thanks, your build system seems faster than mine :)

I've deleted this patch from both the .31 and .32 queues.

greg k-h
