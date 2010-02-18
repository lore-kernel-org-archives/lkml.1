Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab0BRXnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 18:43:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37473
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788Ab0BRXna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 18:43:30 -0500
Date: Thu, 18 Feb 2010 15:43:45 -0800 (PST)
Message-Id: <20100218.154345.28706204.davem@davemloft.net>
To: apetlund@simula.no
Cc: netdev@vger.kernel.org, ilpo.jarvinen@helsinki.fi, eric.dumazet@gmail.com,
       hannemann@nets.rwth-aachen.de, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, william.allen.simpson@gmail.com,
       damian@tvk.rwth-aachen.de, ebiederm@xmission.com, franco@lastsummer.de
Subject: Re: [net-next PATCH v5 0/3] net: TCP thin-stream latency-improving
 modifications
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B7D35A5.10106@simula.no>
References: <4B7D35A5.10106@simula.no>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Petlund <apetlund@simula.no>
Date: Thu, 18 Feb 2010 13:42:13 +0100

> This is a series of patches enabling non-intrusive, dynamically 
> triggered modifications that improve retransmission latencies 
> for thin streams.
> 
> The patch set was modified according to the feedback received.
> 
> Major change:
>       -Used bitfields to compact the nonagle variable
>        in the tcp_sock struct. nonagle, thin_lto and
>        thin_dupack is now contained in the same u8.
> 
> I decided to use bitfields to handle this as it is
> already done similarly in the tcp_options_received struct.
> 
> Also corrected some formatting issues.

All applied (I made sure the get the updated version of patch #3),
thanks a lot!
