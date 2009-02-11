Return-Path: <linux-kernel-owner+w=401wt.eu-S1757913AbZBKQuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbZBKQuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 11:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbZBKQt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 11:49:58 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:50389 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285AbZBKQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 11:49:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=jhYOCwF4E+QtXDpmEPrtRiWhhPF4gF98UeP7goxprBxIw2UsRKB4VZXOro5K7ta56S
         WiwXmFLZUbLyoxcBrKmc9OczIA/bYNwCxre92YgGEPpDyYT536k2TG9UKFugdslF19j1
         0OPLWoRlAyfY7xaczjb7zfh9pw6K0lYeV0Fd0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 4/6] ide: add ->dma_expiry method and remove ->dma_exec_cmd one
Date: Wed, 11 Feb 2009 17:30:39 +0100
User-Agent: KMail/1.10.4 (Linux/2.6.29-rc4-next-20090210; KDE/4.1.4; i686; ; )
Cc: linux-ide@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>,
       linux-kernel@vger.kernel.org
References: <20090209231945.32406.14874.sendpatchset@localhost.localdomain> <20090209232012.32406.88338.sendpatchset@localhost.localdomain> <4991C4F3.2040404@ru.mvista.com>
In-Reply-To: <4991C4F3.2040404@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902111730.39460.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 February 2009, Sergei Shtylyov wrote:
> Bartlomiej Zolnierkiewicz wrote:
> 
> > * Rename dma_timer_expiry() to ide_dma_sff_expiry() and export it.
> 
> > * Add ->dma_expiry method
> 
>     This name doesn't seem to make much sense. Why not leave it dma_timer_expiry?

Well, the name matches with hwif->expiry one + the downside of leaving it at
dma_timer_expiry is a need to reformat all struct ide_dma_ops instances...

Thanks,
Bart
