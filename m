Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbZKTVST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbZKTVST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbZKTVSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:18:18 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:48138 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbZKTVSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:18:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=V2IduTE7AqKOcLAiIVyY/6SoY1Zv3+0A1QXJvV+IaAflFZWMF3ZUG2WNaU0jEQtnEY
         r9bZXIXgj034RYY+s2gj42TOAE6bM34XU59TVx4OJ9W5PdnJKt9akoiaRLrsZHyMQpfl
         z2FfevQ3GxOaginee84fTthEobL4mg2zbgCO8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Date: Fri, 20 Nov 2009 22:17:31 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <200911192249.16860.bzolnier@gmail.com> <4B05C0B1.2020307@garzik.org>
In-Reply-To: <4B05C0B1.2020307@garzik.org>
MIME-Version: 1.0
Message-Id: <200911202217.31982.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 November 2009 11:03:29 pm Jeff Garzik wrote:
> On 11/19/2009 04:49 PM, Bartlomiej Zolnierkiewicz wrote:

> >> Absent stronger justification, libata remains with separate drivers,
> >> even if that means some code duplication.
> >
> > I can always hold my own tree with such changes if needed.
> 
> If it really bugs you, you could take the drivers/ata/sata_promise.h 
> approach, or do multi-file modules.

One of the main problems with separate drivers is a needless complexity
of the detection logic (different chips share same PCI IDs) and relevant
code parts presenting the issue were already posted in this thread.

PS It would bug me really if I were the author or the maintainer of said
code but since I'm not I'll get to fixing it only when I'm bored enough..

--
Bartlomiej Zolnierkiewicz
