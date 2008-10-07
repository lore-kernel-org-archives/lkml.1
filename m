Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbYJGReY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbYJGReY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 13:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbYJGReJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 13:34:09 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:11603 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbYJGReH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 13:34:07 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Arjan van de Ven <arjan@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "JensAxboejens.axboe@oracle.com" <JensAxboejens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       LKML-scsi <linux-scsi@vger.kernel.org>
Date: Tue, 7 Oct 2008 17:33:35 +0000
Subject: RE: [PATCH 1 of 1] cciss: add procfs interface to rescan logical
 volumes
Thread-Topic: [PATCH 1 of 1] cciss: add procfs interface to rescan logical
 volumes
Thread-Index: AckomreEpAj0hTNbQDeDLuQywVVa1gAB40pA
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77884C00C15F14@GVW0547EXC.americas.hpqcorp.net>
References: <20081007162454.GA12104@roadking.ldev.net>
 <20081007093530.1793a81b@infradead.org>
In-Reply-To: <20081007093530.1793a81b@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arjan van de Ven [mailto:arjan@infradead.org]
> Sent: Tuesday, October 07, 2008 11:36 AM
> To: Miller, Mike (OS Dev)
> Cc: Andrew Morton; JensAxboejens.axboe@oracle.com; LKML; LKML-scsi
> Subject: Re: [PATCH 1 of 1] cciss: add procfs interface to
> rescan logical volumes
>
> On Tue, 7 Oct 2008 11:24:54 -0500
> Mike Miller <mike.miller@hp.com> wrote:
>
> > Patch 1 of 1
> >
> > This patch adds a procfs interface so users can force a
> rescan of the
> > logical volumes attached to the controller. A new product
> uses Target
> > Based Management (TBM) out-of-band for configuration purposes. With
> > this method the driver has no way of knowing that something has
> > changed, i.e., new logical volume(s) added or existing volumes
> > deleted. This interface allows the user to echo "rescan volumes" >
> > /proc/driver/cciss/ccissN to force the driver to rebuild
> our table of
> > logical volumes.
> > Please consider this patch for inclusion.
>
>
> I'll ask the obvious question (since you didn't address this)...
> why is this a proc thing and not just a sysfs attribute of the device?
>

Because I'm pretty sysfs stupid. :(

An attribute in sysfs is the ultimate goal but I did this for expediency. Any pointers to sysfs documentation that's either not very outdated or doesn't contradict itself?

Thanks,
mikem

>
> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings, visit
> http://www.lesswatts.org
>
