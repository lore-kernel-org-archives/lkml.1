Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbZALVQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbZALVQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbZALVQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:16:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36777
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753229AbZALVQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:16:32 -0500
Date: Mon, 12 Jan 2009 13:16:32 -0800 (PST)
Message-Id: <20090112.131632.119282940.davem@davemloft.net>
To: dan.j.williams@intel.com
Cc: herbert@gondor.apana.org.au, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hskinnemoen@atmel.com, maciej.sosnowski@intel.com,
       g.liakhovetski@gmx.de, sfr@canb.auug.org.au, netdev@vger.kernel.org,
       s.hauer@pengutronix.de
Subject: Re: [GIT PULL, resend] async_tx/dmaengine update for 2.6.29
From: David Miller <davem@davemloft.net>
In-Reply-To: <e9c3a7c20901120945r2728e6d3oc9237249d748f8dd@mail.gmail.com>
References: <20090112121539.GA6058@gondor.apana.org.au>
	<e9c3a7c20901120945r2728e6d3oc9237249d748f8dd@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Dan Williams" <dan.j.williams@intel.com>
Date: Mon, 12 Jan 2009 10:45:02 -0700

> On Mon, Jan 12, 2009 at 5:15 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > Dan Williams <dan.j.williams@intel.com> wrote:
> >>
> >> net/core/dev.c                        |  149 +------
> >> net/ipv4/tcp.c                        |    5 +-
> >> net/ipv4/tcp_input.c                  |    2 +-
> >> net/ipv4/tcp_ipv4.c                   |    2 +-
> >> net/ipv6/tcp_ipv6.c                   |    2 +-
> >
> > Wouldn't it be better for these changes to go through the net
> > tree?
> >
> 
> It was awkward to separate the reformatting of the core api from its
> users.  In this exceptional case these changes were limited to areas
> inside #ifdef CONFIG_DMA_ENGINE/CONFIG_NET_DMA.
> 
> In general, Maciej and I send purely incremental patches through the
> net tree [1].

Yes, I think in this case it didn't make much sense to send
the changes via the net tree.
