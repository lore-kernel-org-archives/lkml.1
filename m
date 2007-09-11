Return-Path: <linux-kernel-owner+w=401wt.eu-S933901AbXIKVxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901AbXIKVxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934099AbXIKVw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:52:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:43741 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934028AbXIKVwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:52:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=kNj0pNafR7siOIUUCJYMNioaYEx68KQ9c6cGdJWJ8b5Z5gQ4Ui3x4D0TCiJ/Ihz9CHCvA+TmYCPT1D+2M/YTJ+rk5GfG3/mmrfz24mtYZZ1q8kIACAyXKzfyygwx8SkvOf4Lb1rP4VKOLsCODWUcG8pDh4JQBBMYY9X9SWqhsiU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] drivers/firmware: const-ify DMI API and internals
Date: Tue, 11 Sep 2007 23:54:41 +0200
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       Greg KH <greg@kroah.com>, len.brown@intel.com,
       linux-ide@vger.kernel.org, dz@debian.org, minyard@acm.org,
       j.w.r.degoede@hhs.nl, lm-sensors@lm-sensors.org, rlove@rlove.org,
       dmitry.torokhov@gmail.com, mzxreary@0pointer.de, stelian@popies.net,
       ibm-acpi@hmh.eng.br, ambx1@neo.rr.com, gimli@dark-green.com
References: <20070901142719.GA31990@havoc.gtf.org>
In-Reply-To: <20070901142719.GA31990@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709112354.41774.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 September 2007, Jeff Garzik wrote:
> 
> commit 457b6eb3bf3341d2e143518a0bb99ffbb8d754c4
> Author: Jeff Garzik <jeff@garzik.org>
> Date:   Sat Sep 1 10:16:45 2007 -0400
> 
>     drivers/firmware: const-ify DMI API and internals
>     
>     Three main sets of changes:
>     
>     1) dmi_get_system_info() return value should have been marked const,
>        since callers should not be changing that data.
>     
>     2) const-ify DMI internals, since DMI firmware tables should,
>        whenever possible, be marked const to ensure we never ever write to
>        that data area.
>     
>     3) const-ify DMI API, to enable marking tables const where possible
>        in low-level drivers.
>     
>     And if we're really lucky, this might enable some additional
>     optimizations on the part of the compiler.
>     
>     The bulk of the changes are #2 and #3, which are interrelated.  #1 could
>     have been a separate patch, but it was so small compared to the others,
>     it was easier to roll it into this changeset.
>     
>     Signed-off-by: Jeff Garzik <jeff@garzik.org>

[ a bit late ]

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
