Return-Path: <linux-kernel-owner+w=401wt.eu-S1422976AbXBAUBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422976AbXBAUBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 15:01:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422972AbXBAUBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 15:01:13 -0500
Received: from hqemgate01.nvidia.com ([216.228.112.170]:13830 "EHLO
	HQEMGATE01.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422971AbXBAUBK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 15:01:10 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Feb 2007 15:01:10 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5.7226.0
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] SCSI: Add the SGPIO support for sata_nv.c
Date: Thu, 1 Feb 2007 11:55:35 -0800
Message-ID: <8E5ACAE05E6B9E44A2903C693A5D4E8A1CB6ABCE@hqemmail02.nvidia.com>
In-Reply-To: <20070131152136.7d0a05ff.kristen.c.accardi@intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] SCSI: Add the SGPIO support for sata_nv.c
thread-index: AcdFjq+h1zhZ47sUQQCXxowbS93T9wAiRztQ
References: <15F501D1A78BD343BE8F4D8DB854566B0CEB90E0@hkemmail01.nvidia.com><455DF9AE.3000406@garzik.org> <20070131152136.7d0a05ff.kristen.c.accardi@intel.com>
From: "Andy Currid" <ACurrid@nvidia.com>
To: "Kristen Carlson Accardi" <kristen.c.accardi@intel.com>,
       "Jeff Garzik" <jeff@garzik.org>
Cc: "Peer Chen" <pchen@nvidia.com>, "Christoph Hellwig" <hch@infradead.org>,
       "Prakash Punnoor" <prakash@punnoor.de>, "Andrew Morton" <akpm@osdl.org>,
       <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
       "Kuan Luo" <kluo@nvidia.com>
X-OriginalArrivalTime: 01 Feb 2007 19:55:35.0848 (UTC) FILETIME=[F063FA80:01C7463A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'm not sure I understand your point. To support SGPIO initiators
incorporated
into SATA host controllers, it is pretty much inevitable that some SGPIO
support
will have to be added directly into individual drivers for thoese
controllers;
the SGPIO standard does not define a register level interface for
accessing
this functionality, so vendor implementations vary.

It's possible that with an SGPIO initiator integrated within a SAS host
controller,
you may be able to use SMP frames to access it, using the messaging
defined in
SFF-8485 chapter 8 - but I wouldn't bank on it.

Andy

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Kristen Carlson
Accardi
Sent: Wednesday, January 31, 2007 15:22
To: Jeff Garzik
Cc: Peer Chen; Christoph Hellwig; Prakash Punnoor; Andrew Morton;
linux-kernel@vger.kernel.org; linux-ide@vger.kernel.org; Kuan Luo
Subject: Re: [PATCH] SCSI: Add the SGPIO support for sata_nv.c

On Fri, 17 Nov 2006 13:04:30 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> Peer Chen wrote:
> > I didn't get any comment from you guys for new patch, does someone
take
> > care this patch, do we still need some modification upon it? Or do
we
> > need re-submit it in other thread?
> 
> For my part, it's in my queue of things to review.  I need to figure
out 
> the best way to export this support.
> 
> 	Jeff

Adding SGPIO support directly into an individual SATA driver seems to be
a very bad idea since SGPIO is a) a protocol that can be used by many 
different SATA controllers and is not nvidia specific and b) can also
be used by SAS.


-
To unsubscribe from this list: send the line "unsubscribe linux-kernel"
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
