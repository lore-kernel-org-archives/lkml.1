Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbZBSNbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbZBSNbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbZBSNbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:31:35 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:54720 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750851AbZBSNbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:31:34 -0500
Date: Thu, 19 Feb 2009 21:29:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Theodore Tso <tytso@mit.edu>
Cc: davem@davemloft.net, Valdis.Kletnieks@vt.edu, arvidjaar@mail.ru,
       rjw@sisk.pl, netdev@vger.kernel.org,
       bonding-devel@lists.sourceforge.net, jamagallon@ono.com,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 regression? Bonding tied to IPV6 in 29-rc5
Message-ID: <20090219132917.GA11137@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218135537.GF3600@mini-me.lan>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> wrote:
> 
> I think I can pretty much guarantee that distro users will be
> clamoring for a quick and easy way to block ipv6, and it's in our
> interest to document the recomended way to block it that doesn't cause
> weird problems with bonding, etc.

We already have a way:

echo 0 > /proc/sys/net/ipv6/conf/all/disable_ipv6

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
