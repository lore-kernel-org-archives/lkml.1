Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbXI1FiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbXI1FiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 01:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755823AbXI1Fh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 01:37:57 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1082 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755491AbXI1Fh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 01:37:56 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: jbeulich@novell.com (Jan Beulich)
Subject: Re: [PATCH] Module use count must be updated as bridges are	created/destroyed
Cc: shemminger@linux-foundation.org, bridge@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Organization: Core
In-Reply-To: <46FBE2DD.76E4.0078.0@novell.com>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1Ib8Xj-0006Kl-00@gondolin.me.apana.org.au>
Date: Fri, 28 Sep 2007 13:37:39 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich <jbeulich@novell.com> wrote:
>
> So we have an unsolvable problem here then, unless infrastructure gets added
> that allows a module to declare itself as not-implicit-unload-safe, forcing
> modprobe -r to keep its hands off it. Ugly.

Yes I've always wanted to have a separate count that indicates
a module is in use but does not prevent its immediate removal.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
