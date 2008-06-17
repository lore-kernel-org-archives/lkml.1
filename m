Return-Path: <linux-kernel-owner+w=401wt.eu-S1754386AbYFQFjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbYFQFjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 01:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbYFQFjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 01:39:13 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:47838 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751443AbYFQFjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 01:39:13 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: tzeitlho+lkml@nt.tuwien.ac.at (Thomas Zeitlhofer)
Subject: Re: IPSEC in 2.6.25 causes stalled connections
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Organization: Core
In-Reply-To: <20080608010858.GA8877@swan.nt.tuwien.ac.at>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1K8TuP-0002Qd-00@gondolin.me.apana.org.au>
Date: Tue, 17 Jun 2008 15:39:09 +1000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Zeitlhofer <tzeitlho+lkml@nt.tuwien.ac.at> wrote:
> 
> Is this a known issue?

Not to me.  When a connection gets stuck does the SA in question
still function? For instance, can you send a ping through that
exact SA?

Please send us the ip -s x s and ip -s x p output (with your
serect keys removed/obscured).

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
