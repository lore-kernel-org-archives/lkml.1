Return-Path: <linux-kernel-owner+w=401wt.eu-S1750988AbZKZSJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750988AbZKZSJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 13:09:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbZKZSJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 13:09:27 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39124 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbZKZSJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 13:09:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=UnRtokNS4X7UuP1yXBIfr/G6RBKZFiYciGIf7/C0P4/LAChK9eHRgqbUUzrWG5dXOD
         cc7dJkwGBo+K3HS+QHtWcyWN0Zpnjr0wGqrDRqwyFiw3lMqKHs2LWCdS8YEFu59juWnG
         UwiNei4BGhX1WZJpmPoHJ1Sv/2rlAMU4sj8nE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] pata_it8213: MWDMA0 is unsupported
Date: Thu, 26 Nov 2009 19:00:11 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200911261728.36433.bzolnier@gmail.com> <200911261800.55025.bzolnier@gmail.com> <4B0EB986.2010801@ru.mvista.com>
In-Reply-To: <4B0EB986.2010801@ru.mvista.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911261900.11506.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 November 2009 06:23:18 pm Sergei Shtylyov wrote:
> Bartlomiej Zolnierkiewicz wrote:
> 
> >>MWDMA0 timings cannot be met with the PIIX based controller
> >>programming interface.
> 
> >>This change should be safe as this is how we have been doing
> >>things in IDE it8213 host driver for years.
> 
> >>Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >>---
> >>Verified with the documentation (similar case as with pata_efar).
> 
> > Uhhh, no...
> 
> > Too many damn drivers.
> 
> > Too much damn duplication.
> 
> > Too much damn subtle differences here and there.
> 
> > The hardware is probably fine for MWMDA0 when it comes to pata_{efar,it8213},
> > it just not documented properly in the data sheet.
> 
>     How so with pata_efar? The active/recovery bitfields are still 2-bit 
> wide, no?

Yes but when TIMEx bit is disabled we are using XFER_PIO_SLOW timings.

All data sheets including original Intel ones are a complete crap when it
comes to explicitly documenting this behavior.

--
Bartlomiej Zolnierkiewicz
