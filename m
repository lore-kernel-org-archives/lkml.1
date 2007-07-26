Return-Path: <linux-kernel-owner+w=401wt.eu-S933605AbXGZNAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbXGZNAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 09:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbXGZM7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 08:59:52 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:15292 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759018AbXGZM7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 08:59:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FR8WoilnbFyWi7GwWfWGSQX+hxMehcp2r+cmAIs05FM5ys1CxzHnkGBrPN54p0RQ1jUplSeBaZzC9kMGs4l/NuNmOKtllPxVd2AXcFRIySB2AgD4aTQObN7vrIk6PxIwcFHKHtqDXW1aok1lvC0+axAFwIYkP4kNhkyNxpWvoSE=
Message-ID: <7e5f60720707260559m64211206q581a4c83c9060485@mail.gmail.com>
Date: Thu, 26 Jul 2007 14:59:51 +0200
From: "Peter Bortas" <bortas@gmail.com>
To: "Marcus Comstedt" <marcus@mc.pp.se>
Subject: Re: [PATCH] Fix DMA on Dreamcast
Cc: "Adrian McMenamin" <adrianmcmenamin@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lethal@users.sourceforge.net
In-Reply-To: <yf9y7h3a31l.fsf@mc.pp.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <92a12cdb0707191230g216feaf2ied3e95bacf4dd572@mail.gmail.com>
	 <20070720120408.1f190269.akpm@linux-foundation.org>
	 <92a12cdb0707210322m6670acaer768d078c5e358b0c@mail.gmail.com>
	 <7e5f60720707210424w48f9dc10hff044d702f7bd1d3@mail.gmail.com>
	 <92a12cdb0707210506t5cf58cc4gc5b70f335545dc3f@mail.gmail.com>
	 <7e5f60720707210713o4ff0825eu463abee77dc1f04c@mail.gmail.com>
	 <yf9y7h3a31l.fsf@mc.pp.se>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/26/07, Marcus Comstedt <marcus@mc.pp.se> wrote:
>
> "Peter Bortas" <bortas@gmail.com> writes:
>
> > On 7/21/07, Adrian McMenamin <adrianmcmenamin@gmail.com> wrote:
> >> On 21/07/07, Peter Bortas <bortas@gmail.com> wrote:
> >>
> >> >
> >> > Sidenote: Does Linux handle the Dreamcast DMA errata?
> >> >
> >>
> >> You need to explain what you mean (at least to me!).
> >>
> >> If you mean will it degrade gracefully - not without this patch if set
> >> to the (correct) defconfig. With iffy settings it will.
> >
> > If I remember correctly (and that's a big if since I last looked at it
> > in 2001) some revisions of the Dreamcast hardware would sporadically
> > lock up if you scheduled a new DMA request to quickly after a previous
> > one, even if you checked the ready bit. It's worked around by a delay
> > of X microseconds as recommended by Sega engineers. I don't remember
> > the value of X, nor where exactly in the flow this workaround should
> > be applied.
> >
> > Adding Marcus in case he has a better memory than me.
>
>
> I don't remeber any such delay.  Are you sure you're not thinking
> about the G2 bus problem (where accesses need to be programatically
> serialized, whether they are PIO or DMA)?

In that case my memory is worse than I thought. I'll see if I can dig
up my old notes.

-- 
Peter Bortas
