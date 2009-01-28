Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbZA1Gap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbZA1Gap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 01:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbZA1Gah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 01:30:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34746
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751492AbZA1Gag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 01:30:36 -0500
Date: Tue, 27 Jan 2009 22:30:34 -0800 (PST)
Message-Id: <20090127.223034.148914139.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: jpirko@redhat.com, linux-kernel@vger.kernel.org, nhorman@redhat.com
Subject: Re: [PATCH] net: fix xfrm reverse flow lookup for icmp6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090128034816.GA12904@gondor.apana.org.au>
References: <20090126162953.GA17952@psychotron.englab.brq.redhat.com>
	<20090128034816.GA12904@gondor.apana.org.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 28 Jan 2009 14:48:16 +1100

> On Mon, Jan 26, 2009 at 05:29:54PM +0100, Jiri Pirko wrote:
> > This patch fixes the xfrm reverse flow lookup for icmp6 so that icmp6 packets
> > don't get lost over ipsec tunnels. Similar patch is in RHEL5 kernel for a quite
> > long time and I do not see why it isn't in mainline.
> > 
> > Please correct me if I'm missing something.
> > 
> > Jirka
> > 
> > 
> > Signed-off-by: Jiri Pirko <jpirko@redhat.com>
> 
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Indeed, I have no idea how this one slipped through the cracks.
> Thanks for picking up on it!

Yep, thanks for sure.

Applied, thanks again.
