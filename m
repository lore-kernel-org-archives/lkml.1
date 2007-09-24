Return-Path: <linux-kernel-owner+w=401wt.eu-S1759620AbXIXSoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbXIXSoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbXIXSop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:44:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:49196 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040AbXIXSoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:44:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=j6oB1oehooHr+VAE51d5CzBv6SpdqlF7+r95Y7SfAbhtLYKDg7BIpW1FQTolNJ/kDo5/lBYrq9GIHQoo/nMCwwtLJ0JtT/Q/R1dLh32qSSDHPuUqTApTKitp/kQWeSenV/1DvtBFZjkoCoDoJGtM68f7PqCItqwKKMOwhQ7kXcU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 3/4] ide: make ide_rate_filter() also respect PIO and SW/MW DMA mode masks (take 2)
Date: Mon, 24 Sep 2007 20:48:00 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200709022344.18565.sshtylyov@ru.mvista.com> <46E2900D.5010004@ru.mvista.com> <46F7B117.5000202@ru.mvista.com>
In-Reply-To: <46F7B117.5000202@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709242048.00192.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 September 2007, Sergei Shtylyov wrote:
> Once I quothed:
> 
> >> Make ide_rate_filter() also respect PIO/SWDMA/MWDMA mode masks.  While 
> >> at it,
> >> make the udma_filter() method calls take precedence over using the 
> >> mode masks.
> 
> >    This one not looking to pretty -- I've geve some thought on how to 
> > beautify all these switch fallthoughs but haven't got something much 
> > better then uour original approach (AKA Occam's razor :-).
> 
>     So, it's probably better forget about this patch. But please do take patch 
> 4/4 to merge either before or after your "Occam's razor" -- it makes its best 
> at masking out the MWDMA modes anyways...

Sure, could you re-send patch 4/4 synced against current Linus' tree?

Thanks,
Bart
