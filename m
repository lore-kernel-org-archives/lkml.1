Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbZA1Dsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbZA1Dsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 22:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbZA1DsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 22:48:21 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:45851 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752305AbZA1DsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 22:48:21 -0500
Date: Wed, 28 Jan 2009 14:48:16 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jiri Pirko <jpirko@redhat.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, nhorman@redhat.com
Subject: Re: [PATCH] net: fix xfrm reverse flow lookup for icmp6
Message-ID: <20090128034816.GA12904@gondor.apana.org.au>
References: <20090126162953.GA17952@psychotron.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126162953.GA17952@psychotron.englab.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 05:29:54PM +0100, Jiri Pirko wrote:
> This patch fixes the xfrm reverse flow lookup for icmp6 so that icmp6 packets
> don't get lost over ipsec tunnels. Similar patch is in RHEL5 kernel for a quite
> long time and I do not see why it isn't in mainline.
> 
> Please correct me if I'm missing something.
> 
> Jirka
> 
> 
> Signed-off-by: Jiri Pirko <jpirko@redhat.com>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Indeed, I have no idea how this one slipped through the cracks.
Thanks for picking up on it!

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
