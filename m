Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbXFOX1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbXFOX1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757918AbXFOX04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:26:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:63885 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757667AbXFOX0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:26:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Tf7ePUjQcIJTA+sgTJZOTywKSVLpEGR5IbFf/NCL/tTVLOsGZ+rxVDU0CuIWM4Bkpy1Na/nfEf0DZ7xpXR3zppNbmnvTZojupFb6IumK+0VRYY3KyLFX6koo+nuk5j0HncThGqdaDBwDhgEzBjWSbqp9GMyUoH/3EDgBRkqN9Hs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 1/3] Make the IDE DMA timeout modifiable
Date: Sat, 16 Jun 2007 01:23:55 +0200
User-Agent: KMail/1.9.6
Cc: Suleiman Souhlal <ssouhlal@freebsd.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20070221011922.GA1777@freefall.freebsd.org> <200702210342.20775.bzolnier@gmail.com> <466EEFD6.9030001@ru.mvista.com>
In-Reply-To: <466EEFD6.9030001@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706160123.55636.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 June 2007, Sergei Shtylyov wrote:
> Bartlomiej Zolnierkiewicz wrote:
> >>On Feb 20, 2007, at 5:44 PM, Bartlomiej Zolnierkiewicz wrote:
> 
> >>>On Wednesday 21 February 2007 02:19, Suleiman Souhlal wrote:
> 
> >>>>It can be changed via /proc/ide/hd?/settings.
> 
> >>>Why do we need to change IDE DMA timeout dynamically?
> 
> >>I've used it to test error recovery (for example).
> 
> > Seems quite useable for developers but I would prefer not to
> > expose it in production kernels for end users.
> 
>     It seems that I have counter example of a customer asking if this timeout 
> can be done configurable. :-)

May I ask what was the rationale for this request?

I have no strong feelings about adding this /proc/ide/ setting but I worry
that it could be (mis)used just to (unreliably) work-around problems...

>     BTW, why the timeout is so damn long? 2*WAIT_CMD is 20 secs, and if DMA is 
> not complete or interrupt pending, it may wait 10 more secs...

I really don't remember... :)

Maybe Mark or Alan could help with figuring this out.

Thanks,
Bart
