Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbZBFQ7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbZBFQ7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 11:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZBFQ6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 11:58:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:40215 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbZBFQ6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 11:58:54 -0500
Message-ID: <498C6C15.3050807@kernel.org>
Date: Fri, 06 Feb 2009 08:57:57 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>,
       "David S. Miller" <davem@davemloft.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>
Subject: Re: [PATCH] forcedeth: make msi-x different name for rx-tx
References: <498BC3A8.9040203@kernel.org> <20090206144948.GD18368@elte.hu>
In-Reply-To: <20090206144948.GD18368@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Cool cleanups!
> 
> Would you mind to also fix the following - on all my systems that have 
> forcedeth gigabit ethernet i've been getting these bogus warnings for 
> _years_, under moderate load:
> 
>   eth2: too many iterations (16) in nv_nic_irq.
> 
> I think a 64 iterations limit will work much better. (i tried a limit of 50 
> a year ago for a while and it worked fine and had no side effects - and the 
> bogus warnings were done.)

you may enable CONFIG_FORCEDETH_NAPI.

we should enable NAPI for forcedeth by default, and try to squash more bugs out.

YH
