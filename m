Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbZCKRBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbZCKRBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbZCKRBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:01:02 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:10201 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbZCKRA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:00:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=rEcymy8W8PJxvHUkAk0goWaJ+jf/LnmUvy9b1Jd+yOpe7ZxJXwPmbP1hCGh7pOFwT+
         MJlB03jLbGgysgx5PKNceYXqfhPotzSCOaanKni43LvSvEIFxLNazs67FzYtvdBA06s1
         LvA87wCm7DhXB5q/QTsUfoGg3YIkiJC4MP3TE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 07/10] ide: add ->dma_check method
Date: Wed, 11 Mar 2009 17:36:07 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-next-20090310; KDE/4.2.0; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain> <20090220171229.25429.16478.sendpatchset@localhost.localdomain> <49B44781.6050708@ru.mvista.com>
In-Reply-To: <49B44781.6050708@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903111736.08104.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 March 2009, Sergei Shtylyov wrote:
> Bartlomiej Zolnierkiewicz wrote:
> 
> > * Add (an optional) ->dma_check method for checking if DMA can be
> >   used for a given command and fail DMA setup in ide_dma_prepare()
> >   if necessary.
> >
> > * Convert alim15x3 and trm290 host drivers to use ->dma_check.
> >
> > * Rename ali15x3_dma_setup() to ali_dma_setup() while at it.
> >   
> 
>    ali_dma_check() you mean?

Yep, thanks for noticing (it is fixed now).

> > There should be no functional changes caused by this patch.
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >   
> 
> Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
