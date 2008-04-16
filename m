Return-Path: <linux-kernel-owner+w=401wt.eu-S933169AbYDPPwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169AbYDPPwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 11:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758469AbYDPPwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 11:52:19 -0400
Received: from mail.vyatta.com ([216.93.170.194]:42073 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757549AbYDPPwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:52:18 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.944
Date: Wed, 16 Apr 2008 08:52:13 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: zaitcev@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: X or AF_UNIX and order 3 allocation
Message-ID: <20080416085213.1e55bd1e@extreme>
In-Reply-To: <20080415.215144.87148045.davem@davemloft.net>
References: <20080415211055.882e67fe.zaitcev@redhat.com>
	<20080415.215144.87148045.davem@davemloft.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008 21:51:44 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Pete Zaitcev <zaitcev@redhat.com>
> Date: Tue, 15 Apr 2008 21:10:55 -0700
> 
> > Hi, Guys:
> > 
> > Not sure if the problem is caused by X or kernel, but this is what
> 
> It seems to be the b44 driver doing a large huge order allocation.
> 
> That driver only asks for (1536 + 30 + 64) bytes, so I suppose part of
> the problem is that SLAB is using an order 3 allocation to satisfy
> that.
>

The chip needs memory below 1G for DMA, perhaps low memory is getting
exhausted.
