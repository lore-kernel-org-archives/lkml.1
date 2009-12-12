Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbZLLIlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbZLLIlu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 03:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756498AbZLLIlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 03:41:49 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:38121 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755874AbZLLIlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 03:41:49 -0500
Date: Sat, 12 Dec 2009 16:41:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Patrick McHardy <kaber@trash.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Michael S. Tsirkin" <mst@redhat.com>,
       Or Gerlitz <ogerlitz@voltaire.com>,
       "Fischer, Anna" <anna.fischer@hp.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Edge Virtual Bridging <evb@yahoogroups.com>
Subject: Re: [RFC] macvlan: add tap device backend
Message-ID: <20091212084112.GA8948@gondor.apana.org.au>
References: <1259862720-28432-1-git-send-email-arnd@arndb.de> <1259862720-28432-3-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259862720-28432-3-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 06:52:00PM +0100, Arnd Bergmann wrote:
> This is a second prototype of a new interface into the network
> stack, to eventually replace tun/tap and the bridge driver
> in certain virtual machine setups. The code has changed
> significantly, but the goals still remain.

The idea looks pretty sound to me.
 
> I'm posting this mainly to solicit feedback. Not sure how
> chances for integration into 2.6.33 are, given that the merge
> window is opening already.

It's way too late for 2.6.33.  But the earlier this becomes ready
then the earlier it can go into linux-next.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
