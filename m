Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbYBMNoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbYBMNoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 08:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbYBMNoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 08:44:00 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:3257 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbYBMNn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 08:43:59 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 13 Feb 2008 13:43:54.0659 (UTC) FILETIME=[79945730:01C86E46]
Content-class: urn:content-classes:message
Subject: Re: [PATCH] fs/coda: remove static inline forward declarations
Date: Wed, 13 Feb 2008 08:43:53 -0500
Message-ID: <Pine.LNX.4.61.0802130838100.4463@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.64.0802131417460.31652@kivilampi-30.cs.helsinki.fi>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fs/coda: remove static inline forward declarations
Thread-Index: AchuRnmdzJH7zttDTcuYF21qQxidOA==
References: <Pine.LNX.4.64.0802131417460.31652@kivilampi-30.cs.helsinki.fi>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: =?iso-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: <jaharkes@cs.cmu.edu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 13 Feb 2008, [iso-8859-1] Ilpo Järvinen wrote:

> They're defined later on in the same file with bodies and
> nothingin between needs them.
>
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> ---
> include/linux/coda_linux.h |    3 ---
> 1 files changed, 0 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/coda_linux.h b/include/linux/coda_linux.h
> index 1c47a34..31b7531 100644
> --- a/include/linux/coda_linux.h
> +++ b/include/linux/coda_linux.h
> @@ -43,9 +43,6 @@ int coda_getattr(struct vfsmount *, struct dentry *, struct kstat *);
> int coda_setattr(struct dentry *, struct iattr *);
>
> /* this file:  heloers */
> -static __inline__ struct CodaFid *coda_i2f(struct inode *);
> -static __inline__ char *coda_i2s(struct inode *);
> -static __inline__ void coda_flag_inode(struct inode *, int flag);
> char *coda_f2s(struct CodaFid *f);
> int coda_isroot(struct inode *i);
> int coda_iscontrol(const char *name, size_t length);
> -- 
> 1.5.2.2
>

I was taught formally that all procedures must be declared
before they are encountered in a file. This constitutes what
is generally known as "good standards of engineering practice."
It also guarantees a compiler diagnostic if the declaration and
the function doesn't match.

You should not remove things just because you don't think they
are necessary. They do no harm and removing them can cause
code checking tools to issue diagnostic messages.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.28 BogoMips).
My book : http://www.AbominableFirebug.com/
_

****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
