Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890Ab0AGTgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab0AGTgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875Ab0AGTgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:36:16 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:65216 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab0AGTgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:36:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BEqtNrLtSf6APKeR2P+35mssvZ8359jiRRkX63hX+gIO68VnHf9h2AQkZ/XMf5iN1r
         TY31jFEETOM/TXAX2JH8dhUPTHaczbTguTVeUJyrs9sibNA1ANz6EneHkD0ck1fyth5I
         lkYNFfqSIwpbmq06KmnyZUu1d5N/+79vDjtiI=
Date: Thu, 7 Jan 2010 20:36:07 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100107193607.GC3208@del.dom.local>
References: <4B457711.1040008@majjas.com>
 <4B458B36.6050509@majjas.com>
 <20100107074756.GB6258@ff.dom.local>
 <4B459368.2000503@majjas.com>
 <4B45F841.8030407@majjas.com>
 <20100107180114.GB3088@del.dom.local>
 <4B4625BD.3070202@majjas.com>
 <20100107183545.GA3208@del.dom.local>
 <4B462B3C.90506@majjas.com>
 <20100107185040.GB3208@del.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100107185040.GB3208@del.dom.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 07:50:40PM +0100, Jarek Poplawski wrote:
> > Going to rerun with these patches and with and without MMAP. Will
> > also retry both with jumbo frames if possible.
> 
> If MMAP then some "alternative" too. But first no MMAP.

Another things IMHO worth to try: a sky2 module parameter
"disable_msi=1", and CONFIG_DMAR off.

Jarek P.
