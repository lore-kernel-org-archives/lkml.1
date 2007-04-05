Return-Path: <linux-kernel-owner+w=401wt.eu-S1767359AbXDEV4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767359AbXDEV4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 17:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767362AbXDEV4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 17:56:09 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:29266 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1767359AbXDEV4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 17:56:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4bixMc9v1l8fTaV/BGnypLLqFzq2/lS/YmlgMN4yqlQSbtsIY3RdCimRONeKactBD9c0hPR5dw4uL8huNYWIZhAvWiUv5NyeQ4KC8Xzren5kWAQzHMjFLzJEL+9rFV4bTvR91IAud9bhecAWUHrN2DDTY/eO3Hbiqtn3v0/YppQ=  ;
X-YMail-OSG: GIGRQ8UVM1k.Nxi8cqafxcQdGfJUgnaMO7_p57jPT5HYb7NjY2abwzvEz29v24Jv6H5mVtSW5w--
From: David Brownell <david-b@pacbell.net>
To: bryan.wu@analog.com
Subject: Re: [PATCH] USB gadget rndis: fix bug skb_push function may return an unaligned pointer bug
Date: Thu, 5 Apr 2007 14:29:03 -0700
User-Agent: KMail/1.7.1
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <1175668113.10608.41.camel@roc-desktop>
In-Reply-To: <1175668113.10608.41.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704051429.04147.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 April 2007 11:28 pm, Wu, Bryan wrote:
> USB gadget rndis: skb_push function may return a pointer which is not
> aligned as required by struct rndis_packet_msg_type.

Can you instead try to update the declaration of that struct
so that it's "__attribute__((packed))"?  That's less invasive,
and will address similar issues elsewhere ...

- Dave
