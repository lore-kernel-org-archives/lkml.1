Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921Ab0AKWs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab0AKWs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 17:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629Ab0AKWsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 17:48:25 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:61821 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab0AKWsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 17:48:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ytw9e1G4avHXSrUCizWNDgjAOP8gKxW6CsxfOVzYqZc22KdoEUHFHwWRRL83/SekBJ
         epheys7TnfvY50UN0Fs5ClwZ/XinwKtwr8XoaEUJ+VeibDfJA4AJe+Q148RCX69XyL/X
         OX0obnGkJq7SzxsOthGrd8LpClKlkRYth7t98=
Date: Mon, 11 Jan 2010 23:48:17 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: David Miller <davem@davemloft.net>, shemminger@vyatta.com,
       akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-2.6 alt.3] af_packet: Don't use skb after
 dev_queue_xmit()
Message-ID: <20100111224817.GB3369@del.dom.local>
References: <20100111080419.GA6061@ff.dom.local>
 <4B4BA695.7040803@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4BA695.7040803@majjas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 05:30:45PM -0500, Michael Breuer wrote:
> On 1/11/2010 3:04 AM, Jarek Poplawski wrote:
...
> >---------------->  (alternative 3)
> >
> >Subject: af_packet: Don't use skb after dev_queue_xmit()
> >
> >tpacket_snd() can change and kfree an skb after dev_queue_xmit(),
> >which is illegal.
> >
> >With debugging by: Stephen Hemminger<shemminger@vyatta.com>
> >
> >Reported-by: Michael Breuer<mbreuer@majjas.com>
> >Signed-off-by: Jarek Poplawski<jarkao2@gmail.com>
> >
> >Cc: Stephen Hemminger<shemminger@vyatta.com>
> >---
> >
> >  net/packet/af_packet.c |   19 ++++++++++++++-----
> >  1 files changed, 14 insertions(+), 5 deletions(-)
...
> Tested by: Michael Breuer
> 
> Note: This patch is delivering better ethernet throughput (15-20%)
> and no  than the previous two patches. I'm also no longer seeing
> dropped RX packets. Good work!

David, if this patch is acceptable now, please add:

With help from: David S. Miller <davem@davemloft.net>

Tested-by: Michael Breuer<mbreuer@majjas.com>

Thanks everybody,
Jarek P.
