Return-Path: <linux-kernel-owner+w=401wt.eu-S1759218AbXGCUPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218AbXGCUPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 16:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbXGCUPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 16:15:43 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:27884 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbXGCUPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 16:15:43 -0400
Date: Tue, 3 Jul 2007 13:16:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: caglar@pardus.org.tr
Cc: "Ni@m" <niam.niam@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] for NIKON D50 as UMS
Message-Id: <20070703131635.baf20b19.randy.dunlap@oracle.com>
In-Reply-To: <200707032310.33106.caglar@pardus.org.tr>
References: <a9e22dff0707031303i30c08439t3cc48fb1b95f29b8@mail.gmail.com>
	<200707032310.33106.caglar@pardus.org.tr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007 23:10:32 +0300 S.Çağlar Onur wrote:

> Hi;
> 
> 03 Tem 2007 Sal tarihinde, Ni@m şunları yazmıştı: 
> > This short patch allows NIKON D50 to be mounted as UMS on 2.6.22-rc7,
> > some previous kernels...

Patch needs a Signed-off-by: line (see Documentation/SubmittingPatches)
and needs to be sent to linux-usb-devel@lists.sf.net and/or
usb-storage@lists.one-eyed-alien.net .


> > --- linux-2.6.22-rc7/drivers/usb/storage/unusual_devs.h 2007-07-03
> > 22:54:23.000000000 +0300
> > +++ linux-2.6.22-rc7-niam/drivers/usb/storage/unusual_devs.h
> > 2007-07-03 22:35:39.000000000 +0300
> > @@ -313,6 +313,13 @@
> >                 US_SC_DEVICE, US_PR_DEVICE,NULL,
> >                 US_FL_NOT_LOCKABLE ),
> >
> > +/* Reported by Niam <niam.niam@gmail.com> */
> > +UNUSUAL_DEV(  0x04b0, 0x0409, 0x0100, 0x0100,
> > +               "NIKON",
> > +               "NIKON DSC D50",
> > +               US_SC_DEVICE, US_PR_DEVICE, NULL,
> > +               US_FL_FIX_CAPACITY),
> > +
> >  /* Reported by Andreas Bockhold <andreas@bockionline.de> */
> >  UNUSUAL_DEV(  0x04b0, 0x0405, 0x0100, 0x0100,
> >                 "NIKON",
> 
> Hmm i have NIKON D50 also and it works here without a problem with Linus's 
> current git. 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
