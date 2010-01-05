Return-Path: <linux-kernel-owner+w=401wt.eu-S1750868Ab0AEFF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750868Ab0AEFF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 00:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763Ab0AEFF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 00:05:28 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:56423 "HELO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750716Ab0AEFF2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 00:05:28 -0500
X-Greylist: delayed 1319 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2010 00:05:27 EST
From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
To: Greg KH <gregkh@suse.de>, Stefan Lippers-Hollmann <s.L-H@gmx.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
       "stable@kernel.org" <stable@kernel.org>
Date: Tue, 5 Jan 2010 10:13:18 +0530
Subject: RE: patch
 scsi-mpt2sas-add-missing-initialization-of-scsih_cmds.patch added to
 2.6.32-stable tree
Thread-Topic: patch
 scsi-mpt2sas-add-missing-initialization-of-scsih_cmds.patch added to
 2.6.32-stable tree
Thread-Index: AcqNl+9t3ClWjyKzRpKr9TDB8HERzAAKKwcA
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C93D49BBE@inbmail01.lsi.com>
References: <12626340131357@kroah.org> <201001042255.07139.s.L-H@gmx.de>
 <20100104234401.GA10770@suse.de>
In-Reply-To: <20100104234401.GA10770@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg and Stefan,

This patch is counter part of 
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=744090d38b47ed8ead8f68b6f0c65866c0b9b17a

.31 And .32 does not required this patch to be added, since it does not have commit 744090d38b47ed8ead8f68b6f0c65866c0b9b17a.

Thanks,
Kashyap

> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Tuesday, January 05, 2010 5:14 AM
> To: Stefan Lippers-Hollmann
> Cc: linux-kernel@vger.kernel.org; Desai, Kashyap; James.Bottomley@suse.de;
> stable@kernel.org
> Subject: Re: patch scsi-mpt2sas-add-missing-initialization-of-
> scsih_cmds.patch added to 2.6.32-stable tree
> 
> On Mon, Jan 04, 2010 at 10:55:02PM +0100, Stefan Lippers-Hollmann wrote:
> > Hi
> >
> > On Monday 04 January 2010, gregkh@suse.de wrote:
> > > This is a note to let you know that we have just queued up the patch
> titled
> > >
> > >     Subject: SCSI: mpt2sas: add missing initialization of scsih_cmds
> > >
> > > to the 2.6.32-stable tree.  Its filename is
> > >
> > >     scsi-mpt2sas-add-missing-initialization-of-scsih_cmds.patch
> >
> > Adding this patch to 2.6.32 (and likely 2.6.31 as well) breaks building
> the
> > current stable queue:
> >
> >   LD      drivers/scsi/mpt2sas/built-in.o
> >   CC [M]  drivers/scsi/mpt2sas/mpt2sas_base.o
> > drivers/scsi/mpt2sas/mpt2sas_base.c: In function 'mpt2sas_base_attach':
> > drivers/scsi/mpt2sas/mpt2sas_base.c:3500: error: 'struct
> MPT2SAS_ADAPTER' has no member named 'scsih_cmds'
> > drivers/scsi/mpt2sas/mpt2sas_base.c:3501: error: 'struct
> MPT2SAS_ADAPTER' has no member named 'scsih_cmds'
> > drivers/scsi/mpt2sas/mpt2sas_base.c:3502: error: 'struct
> MPT2SAS_ADAPTER' has no member named 'scsih_cmds'
> > make[6]: *** [drivers/scsi/mpt2sas/mpt2sas_base.o] Error 1
> > make[5]: *** [drivers/scsi/mpt2sas] Error 2
> 
> Thanks, your build system seems faster than mine :)
> 
> I've deleted this patch from both the .31 and .32 queues.
> 
> greg k-h
