Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbZGEDpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbZGEDpq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 23:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbZGEDpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 23:45:36 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:50501 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753445AbZGEDpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 23:45:35 -0400
Date: Sun, 5 Jul 2009 11:44:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: starlight@binnacle.cx, eric.dumazet@gmail.com,
       linux-kernel@vger.kernel.org, mel@csn.ul.ie, linux-mm@kvack.org,
       hugh.dickins@tiscali.co.uk, Lee.Schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, ebmunson@us.ibm.com, agl@us.ibm.com,
       apw@canonical.com, wli@movementarian.org, netdev@vger.kernel.org
Subject: Re: QUESTION: can netdev_alloc_skb() errors be reduced  by  tuning?
Message-ID: <20090705034448.GA7588@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3737CE.3020305@gmail.com>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> Because of slab rounding, this reallocation should be done only if resulting data
> portion is really smaller (50 %) than original skb.

If we're going to do this in the core then we should only do it
in the spots where the packet may be held indefinitely.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
