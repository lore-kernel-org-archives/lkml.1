Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487Ab0ASIla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab0ASIla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465Ab0ASIl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:41:29 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:59045 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab0ASIl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:41:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TQlvjLmIw98haY5W4r9Ss1guliAEVGP4TXQ3jZTOdM8RkSZXPjkUdCDDzC6BpCwK44
         pxrX0oB7FL3HkC7xlorZ2C2QqBEViKKgPEAnfh4IA06rJxpGD/B1hfKIrdxzDKeGquCx
         VnvrymKpcqlu66trqjKWLYUheh4MLbBUUM3sY=
Date: Tue, 19 Jan 2010 08:41:20 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100119084120.GA6366@ff.dom.local>
References: <20100118073018.GA6270@ff.dom.local> <4B548C6B.10607@majjas.com> <20100118204658.GC3157@del.dom.local> <4B54CB0D.5070604@majjas.com> <20100118212516.GE3157@del.dom.local> <4B54D50C.90608@majjas.com> <20100118220814.GG3157@del.dom.local> <20100118221747.GH3157@del.dom.local> <4B54E4EF.8080602@majjas.com> <4B554730.6090000@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B554730.6090000@majjas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 12:46:24AM -0500, Michael Breuer wrote:
> So net-net, as far as my TX packet loss issue, sky2 is in the clear. If  
> something on the linux side should be informing the switch about  
> something then there may still be an issue. If the wifi router should be  
> doing something differently, then it's unfortunately likely a 2.4.37  
> kernel issue (That's what dd-wrt is using).

IMHO until there is no proof from a sniffer or some regs dumps the
switch and the router are more suspicious than your NIC or linux box.
Then debugging these other things isn't so much interesting from my
POV ;-)

Anyway, if you only want to get it working (instead of debugging),
it seems you might try moving the dhcp server to the router or maybe
even using two separate servers with their pools - unless I missed
something in your config.

Jarek P.
