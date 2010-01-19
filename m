Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456Ab0ASU3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab0ASU3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 15:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650Ab0ASU3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 15:29:30 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:63760 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab0ASU33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 15:29:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IkHtUiHNXz4tPhb9vh45fvyi9HFNDWOFb9Eq0bZPhQyTDGyPgWP08l9y2JAMbV6hcX
         dLcTK3jmuCTCkdsq7SI6893IbYBMhpIfYN1YEa4aa24VW2ZMiRRqrHQm8D4CSZTqsG/S
         m4aYNRUnqMHvuUvT1opCnW1wL4ZHpj35XbcEU=
Date: Tue, 19 Jan 2010 21:29:22 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100119202922.GB3060@del.dom.local>
References: <20100118212516.GE3157@del.dom.local>
 <4B54D50C.90608@majjas.com>
 <20100118220814.GG3157@del.dom.local>
 <20100118221747.GH3157@del.dom.local>
 <4B54E4EF.8080602@majjas.com>
 <4B554730.6090000@majjas.com>
 <20100119104739.GA9088@ff.dom.local>
 <4B55D40F.5080509@majjas.com>
 <20100119195933.GA3060@del.dom.local>
 <4B5610A9.7030902@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5610A9.7030902@majjas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 03:06:01PM -0500, Michael Breuer wrote:
> On 1/19/2010 2:59 PM, Jarek Poplawski wrote:
> >On Tue, Jan 19, 2010 at 10:47:27AM -0500, Michael Breuer wrote:
> >...
> >>Still get the warning... but now 60 bytes.
> >>Jan 19 10:43:50 mail kernel: ------------[ cut here ]------------
> >>Jan 19 10:43:50 mail kernel: WARNING: at lib/dma-debug.c:902
> >Thanks for trying this.
> >Jarek P.
> NP. Let me know what else I can do to help with this one. Note that
> it seems innocuous. I'll continue with the older set and no dmar for
> now and see if I get another crash.

I'll try to look at it more. Since, as you predicted, this might be
connected with dmar problems, it needs some ideas for debugging/fixing
and until this time you could give it a rest from crashing.

Jarek P.
