Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197Ab0ARWIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab0ARWIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 17:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668Ab0ARWIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 17:08:21 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:60808 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab0ARWIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 17:08:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=haRfQYldkeRamiNdjn7+IdeskmtBgjQkOhMhWMviaUshnbWxDXiPXtYVLJaQfIsnaZ
         Vxrf+F91V4r+/7fm15W31N2FVvtA/8LnTjex+LZzW2TkCcaIpxhqdmjr1tBkmo8S1X/A
         k9I4nhuLxrKVjqsBo2phAFeUOX+OzRyjFFAc0=
Date: Mon, 18 Jan 2010 23:08:14 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100118220814.GG3157@del.dom.local>
References: <20100117221746.GA3161@del.dom.local>
 <4B53906B.2020608@majjas.com>
 <20100117230531.GC3161@del.dom.local>
 <4B539A0A.2000504@majjas.com>
 <20100118073018.GA6270@ff.dom.local>
 <4B548C6B.10607@majjas.com>
 <20100118204658.GC3157@del.dom.local>
 <4B54CB0D.5070604@majjas.com>
 <20100118212516.GE3157@del.dom.local>
 <4B54D50C.90608@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B54D50C.90608@majjas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 04:39:24PM -0500, Michael Breuer wrote:
> Some output from tc -s qdisc:
...
> After the conclusion of the test:
> qdisc pfifo_fast 0: dev eth0 root refcnt 2 bands 3 priomap  1 2 2 2
> 1 2 0 0 1 1 1 1 1 1 1 1
>  Sent 244900497 bytes 3416350 pkt (dropped 0, overlimits 0 requeues 0)
>  rate 0bit 0pps backlog 0b 0p requeues 0
> qdisc pfifo_fast 0: dev eth1 root refcnt 2 bands 3 priomap  1 2 2 2
> 1 2 0 0 1 1 1 1 1 1 1 1
>  Sent 564380 bytes 4708 pkt (dropped 0, overlimits 0 requeues 0)
>  rate 0bit 0pps backlog 0b 0p requeues 0

Great!

> 
> 
> During the test, 8.9GB received; 232.9MB sent).
> 
> I also connected a second device through the wifi router. I was able
> to ping that device w/o loss while DHCP packets were being dropped
> to the other connected device.

Could you remind us if the problem is always with this first device?
Btw, I wonder if you could test it skipping the (HP?) switch?

Jarek P.
