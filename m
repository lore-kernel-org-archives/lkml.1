Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbXEJWMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbXEJWMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762119AbXEJWMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:12:17 -0400
Received: from gw.goop.org ([64.81.55.164]:56067 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030AbXEJWMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:12:15 -0400
Message-ID: <464398BB.8030606@goop.org>
Date: Thu, 10 May 2007 15:12:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: herbert@gondor.apana.org.au, hch@infradead.org, ak@suse.de,
       akpm@linux-foundation.org, virtualization@lists.osdl.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       ian.pratt@xensource.com, Christian.Limpach@cl.cam.ac.uk,
       netdev@vger.kernel.org, jeff@garzik.org, shemminge@linux-foundation.org,
       rusty@rustcorp.com.au, Valdis.Kletnieks@vt.edu
Subject: Re: [1/2] [NET] link_watch: Move link watch list into net_device
References: <463F95C3.60407@goop.org>	<20070508121322.GA21647@gondor.apana.org.au>	<464395E5.2090500@goop.org> <20070510.150750.118628150.davem@davemloft.net>
In-Reply-To: <20070510.150750.118628150.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jeremy Fitzhardinge <jeremy@goop.org>
> Date: Thu, 10 May 2007 15:00:05 -0700
>
>   
>> Herbert Xu wrote:
>>     
>>> [NET] link_watch: Move link watch list into net_device
>>>
>>> These days the link watch mechanism is an integral part of the
>>> network subsystem as it manages the carrier status.  So it now
>>> makes sense to allocate some memory for it in net_device rather
>>> than allocating it on demand.
>>>       
>> I think there's a problem with one of these two patches.
>>     
>
> Yes, there are :-)
>
> Did you catch the follow-on bug fixes?
>   

Nope.  Guess I got dropped from the cc: list.  Was this on lkml or netdev?

    J

