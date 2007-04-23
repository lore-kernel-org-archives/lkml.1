Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbXDWWac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbXDWWac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 18:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbXDWWac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 18:30:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:32073 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbXDWWaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 18:30:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=tlBh+NDbo+hZOEwxtHI/2uRat4aTroVy1cvPSeWper04k3+5l2je64CzloSooVzx1sluOkJtdrzm4h+AUADgEPp+azi/Ec/ZhSlQF3zUZzowDHMOHB5ShTL6LiTfklZPwfuE5QtZqgx830RQi6YPa38UF9trkfpcPt9DEUuCWmE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH pata-2.6 fix queue] aec62xx: fix PIO/DMA setup issues
Date: Tue, 24 Apr 2007 00:33:21 +0200
User-Agent: KMail/1.9.6
Cc: codermattie@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200702032309.43867.sshtylyov@ru.mvista.com> <200702162321.40813.sshtylyov@ru.mvista.com> <200704222205.27410.sshtylyov@ru.mvista.com>
In-Reply-To: <200704222205.27410.sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704240033.21244.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 April 2007, Sergei Shtylyov wrote:
> Teach the driver's tuneproc() method to do PIO auto-runing properly since it
> treated 5 instead of 255 as auto-tune request, and also passed the mode limit
> of PIO5 to ide_get_best_pio_mode() despite supporting up to PIO4 only.
> 
> While at it, also:
> 
> - remove the driver's wrong claim about supporting SWDMA modes;
> 
> - stop hooking ide_dma_timeout() method as the handler clearly doesn't fit for
>   the task...
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> 
> ---
> Warning: the patch has only been compile tested (the driver was on the way of
> some cleanup -- that's why I got around to fixing it :-).

applied
