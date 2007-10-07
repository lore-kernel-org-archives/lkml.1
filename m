Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbXJGNda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbXJGNda (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 09:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXJGNdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 09:33:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44038 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbXJGNdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 09:33:18 -0400
Message-ID: <4708E016.9020300@garzik.org>
Date: Sun, 07 Oct 2007 09:33:10 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: netdev <netdev@vger.kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, den@openvz.org,
       David Miller <davem@davemloft.net>
Subject: Re: [NET] IPv6 oops bisected
References: <4708D677.1030601@garzik.org>
In-Reply-To: <4708D677.1030601@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> The commit
> 
> commit 5f5dace1ce001b24fb8286e09ffd3c4d2b547e09
> Author: Denis V. Lunev <den@openvz.org>
> Date:   Thu Sep 27 12:41:26 2007 -0700
> 
>     [NET]: Various dst_ifdown routines to catch refcounting bugs
> 
> causes a 100% reproducible oops in net-2.6.24.git, in ip6_route_add().
> 
> Platform: x86-64 Fedora 7
> 
> Config and lspci attached.

And indeed, reverting this commit with 'patch -R' makes things work again.

	Jeff



