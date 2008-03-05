Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbYCEQOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbYCEQOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758532AbYCEQNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:13:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:13674 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176AbYCEQNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:13:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BeiadAYXI0Np4VFR64t0fK9KHdQTlqnxptaNLBMZeBq+5Mh+Y+Qs/EsweQBP/9aNpz3+G0idJb3LL9VPG/5zXDM4/SM6oMSUGLXX/y5V4RdXVYUWSYtOo+nknuVXGVFJM5BYDHsZZELdYIowO/JQXsRvjEAsCl/tm+NDEm+/Z9A=
Message-ID: <58cb370e0803050813q6cb1082cy7e540a77993f3dd6@mail.gmail.com>
Date: Wed, 5 Mar 2008 17:13:49 +0100
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 3/3] pata: "I do not think it means, what you think it means."
Cc: "Andrew Morton" <akpm@linux-foundation.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, alan@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080305143949.1f56017c@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803042316.m24NGI7k002489@imap1.linux-foundation.org>
	 <20080304173058.7679b7c8.akpm@linux-foundation.org>
	 <20080305115610.397b3ea3@the-village.bc.nu>
	 <200803051421.14167.bzolnier@gmail.com>
	 <20080305143949.1f56017c@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2008 at 3:39 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > There is strange coincidence with being on the blacklist and FIFO corruption.
>  >
>  > https://bugzilla.redhat.com/show_bug.cgi?id=433557
>  >
>  > Bugzilla Bug 433557: Data corrupion with Fedora8 on HPT370 disk controller (Abit BX133 mobo)
>  >
>  > IBM-DTLA-307030 is on the blacklist....
>
>  I wish it was more than a co-incidence but the trace shows it dropped
>  speed as expected.

the trace shows only ST380011A (ata1) dropping speed...

I would suggest that you ask Wojciech to test the patch
(unless it has already happend).

>  > for OSB4 yes but...
>  >
>  > /* Seagate Barracuda ATA IV Family drives in UDMA mode 5
>  >  * can overrun their FIFOs when used with the CSB5 */
>
>  Which gives you a CRC error according to my notes

I have no documentation / errata for ServerWorks chipsets (everything is
NDA-ed) or the hardware in question so I'll trust your opinion on this.

Thanks,
Bart
