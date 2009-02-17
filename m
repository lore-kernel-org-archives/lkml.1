Return-Path: <linux-kernel-owner+w=401wt.eu-S1753109AbZBQOPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbZBQOPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 09:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZBQOP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 09:15:28 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:46674 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbZBQOP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:15:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:content-type
         :content-transfer-encoding:message-id;
        b=HjdGgAUD3lqjwF/lypSuIJHNKkUC/D8BRIdT5jShqKGeh6+IwrcIgrUOAkyFAFzEYN
         MUkV7bHq4NYIrwwLW4JRHPtoiOdtHx7cZ6q57SFDltynbXPYpNZ1qxXm3vDz6xK6GfDi
         09yJnxgYVmYrEVqOww96BWWt9gGtmnIDDfcX4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 4/6] ide: add ->dma_expiry method and remove ->dma_exec_cmd one
Date: Tue, 17 Feb 2009 15:16:33 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc4-next-20090213; KDE/4.2.0; i686; ; )
Cc: linux-ide@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>,
       linux-kernel@vger.kernel.org
References: <20090209231945.32406.14874.sendpatchset@localhost.localdomain> <200902111730.39460.bzolnier@gmail.com> <49930B2D.8090503@ru.mvista.com>
In-Reply-To: <49930B2D.8090503@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200902171516.34091.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 February 2009, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> >>Bartlomiej Zolnierkiewicz wrote:
> 
> >>>* Rename dma_timer_expiry() to ide_dma_sff_expiry() and export it.
> 
> >>>* Add ->dma_expiry method
> 
> >>    This name doesn't seem to make much sense. Why not leave it dma_timer_expiry?
> 
> > Well, the name matches with hwif->expiry one + the downside of leaving it at
> > dma_timer_expiry is a need to reformat all struct ide_dma_ops instances...

On the 2nd look it doesn't seem to be a problem (I must have been looking at
some odd case previously) -- I'll fix it up later.
