Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbXIBEF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbXIBEF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 00:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbXIBEFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 00:05:12 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1899 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750748AbXIBEFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 00:05:11 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: kaber@trash.net (Patrick McHardy)
Subject: Re: [Bugme-new] [Bug 8961] New: BUG triggered by oidentd in netlink code
Cc: link@miggy.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
Organization: Core
In-Reply-To: <46D9957F.4020101@trash.net>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1IRghZ-0004EL-00@gondolin.me.apana.org.au>
Date: Sun, 02 Sep 2007 12:04:45 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy <kaber@trash.net> wrote:
> 
> Thanks. I'm not sure either, it would require two concurrent requests
> to be processed, but AFAICS oidentd only uses a single netlink socket.
> Perhaps multiple running instances or something else using the inet_diag
> interface?

Since identd serves requests from the outside world it is
quite possible for two identd instances to run simultaneously
serving two requests.

I'm not familiar with oidentd but this is certainly pidentd
works.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
