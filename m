Return-Path: <linux-kernel-owner+w=401wt.eu-S1752604Ab0AGUWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab0AGUWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 15:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418Ab0AGUWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 15:22:43 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:33798 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab0AGUWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 15:22:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UeRPT++HfA+JmCXJLzBj+zgX9A4NJJS9t8I33yKzuTeOy+I8u6P0UPpMvFFeH+YMl7
         u0qWyHYUt5SBldrvsKFGa1ONxGmX7viu5ewjGnu5JYUvcD9JfdkUVGwpaudZ0zszYlFq
         xfFVNGfmpdKnFU5eEiYQq3hWy134ZRMQr9uH4=
Date: Thu, 7 Jan 2010 21:22:35 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100107202235.GA3593@del.dom.local>
References: <20100107074756.GB6258@ff.dom.local>
 <4B459368.2000503@majjas.com>
 <4B45F841.8030407@majjas.com>
 <20100107180114.GB3088@del.dom.local>
 <4B4625BD.3070202@majjas.com>
 <20100107183545.GA3208@del.dom.local>
 <4B462B3C.90506@majjas.com>
 <20100107185040.GB3208@del.dom.local>
 <20100107193607.GC3208@del.dom.local>
 <4B463C2A.2090209@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B463C2A.2090209@majjas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 02:55:22PM -0500, Michael Breuer wrote:
> On 1/7/2010 2:36 PM, Jarek Poplawski wrote:
> >On Thu, Jan 07, 2010 at 07:50:40PM +0100, Jarek Poplawski wrote:
> >>>Going to rerun with these patches and with and without MMAP. Will
> >>>also retry both with jumbo frames if possible.
> >>If MMAP then some "alternative" too. But first no MMAP.
> >Another things IMHO worth to try: a sky2 module parameter
> >"disable_msi=1", and CONFIG_DMAR off.
> >
> >Jarek P.
> Ok - that'd be with or without MMAP enabled? (note that so-far,
> without MMAP I'm not seeing any errors - throughput is running about
> half what I was seeing with MMAP enabled (before crashing that is).
> CPU is also way busier (also to be expected). One other observation
> - I had been seeing lots of DNS errors - IPV6 related format errors
> I really didn't think much of it as they were mostly .ru and seemed
> spam-related, but now I don't see any. Haven't updated bind; doubt
> the world has changed - so perhaps this is related to the network
> issue.

MMAP enabled (with some "alternative" patch - to avoid known bugs)
should give as earlier the answer if these changes matter. But first
let's try longer (if possible) if this "no MMAP" could really heal
your hardware.

Jarek P.
