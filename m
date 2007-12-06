Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbXLFVrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbXLFVrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 16:47:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbXLFVrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 16:47:45 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:47989 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbXLFVro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 16:47:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UOFB7nm9wursxEm5jzyD1KFBNEV1zyJ/QzXMFpM3O9q3AMnzKHOnq6SQMEWOWSDhSpXrleu5fbIdFoocTLwE9OMVhjspCrlvmxl2Ivfgz3vpyRyfyzHIFSZ9tZGMW4TUIg0r2GTNHvwltBOHjK/T3IZjChPOIQRMIpdg3p95xCY=
Message-ID: <b1bc6a000712061337o189b96bal45c0b7b5b7d47568@mail.gmail.com>
Date: Thu, 6 Dec 2007 13:37:28 -0800
From: "adam radford" <aradford@gmail.com>
To: "Gabriele Gorla" <gorlik@yahoo.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: Patch submission question [not in the FAQ]
In-Reply-To: <602863.12913.qm@web53712.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <602863.12913.qm@web53712.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 5, 2007 3:36 AM, Gabriele Gorla <gorlik@yahoo.com> wrote:
> Hello,
> I have submitted a patch for the 3x-xxxx driver on
> alpha several months ago to both the driver maintainer
> and the linux-scsi mailing list.
> I have read all the FAQ and I tried to stick to the
> instructions to the letter.
> However the patch has been completely ignored. No
> reply, no comment, no flames, absolutely nothing...
>
> the original email submission is at the end of the
> email.
>
> could anyone please explain what I am doing wrong?
>
> thanks,
> GG

Gabriele,

I ignored your patch because:

1. I do not believe you have the 3w-xxxx driver running on an
   alpha SMP system.

2. I removed the bitfields from the 3w-xxxx driver but I have
   yet to add full big endian support due to lack of demand.  I have
   such a patch for this driver (which already includes the unpacking
   of the wait_queue_head_t variable) but I have not submitted it to
   the main-line kernel.  The in-kernel 3w-xxxx driver is still missing
   the byte-swaps.

   The 3w-9xxx (9000 series 3ware driver) has full big endian support.

3. Your patch was garbled.

Is this an official request for big endian support for the 3w-xxxx driver or
are you looking for anybody who has a packed 'wait_queue_head_t' and
submitting a patch to fix it?

-Adam
