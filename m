Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698Ab0ARVGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab0ARVGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664Ab0ARVGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:06:22 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:45082 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab0ARVGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:06:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f207Q8QkIsJAKqFMAk6HL2sYJXAvbdlNgurXS84kU1yIZot7DP66wvk649Z/R3sx2W
         +1hem1WSei74I8M0Q4TKyJauxELrx/UNDkKwen6l5UEf5gDZO9hRkXoy2o8WyC2Jv0Zw
         fO3xgDfWiECzmSQvlmu2VjKOThWafpn6+Cc5Q=
Date: Mon, 18 Jan 2010 22:06:15 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Michael Breuer <mbreuer@majjas.com>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100118210615.GD3157@del.dom.local>
References: <4B533A46.9050600@majjas.com>
 <20100117221746.GA3161@del.dom.local>
 <4B53906B.2020608@majjas.com>
 <20100117230531.GC3161@del.dom.local>
 <4B539A0A.2000504@majjas.com>
 <20100118073018.GA6270@ff.dom.local>
 <4B548C6B.10607@majjas.com>
 <20100118204658.GC3157@del.dom.local>
 <4B54CB0D.5070604@majjas.com>
 <20100118130038.77a3adfb@nehalam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118130038.77a3adfb@nehalam>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 01:00:38PM -0800, Stephen Hemminger wrote:
> On Mon, 18 Jan 2010 15:56:45 -0500
> Michael Breuer <mbreuer@majjas.com> wrote:
> 
> > >> 2. The dropped tx packet (DHCP) is a bit harder to recreate, but it
> > >> still happens.
> > >>        
> 
> You might want to use tc filter rule to set priority of DHCP packets
> higher. This would cause them to be in a separate queue and eliminate
> the problem.
> 

But it looks like they are dropped in TX after passing a qdisc (and
wireshark).

Jarek P.
