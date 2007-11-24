Return-Path: <linux-kernel-owner+w=401wt.eu-S1752922AbXKXGBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbXKXGBH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 01:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbXKXGAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 01:00:53 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3120 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751112AbXKXGAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 01:00:52 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: davids@webmaster.com
Subject: Re: [RFC/PATCH] SO_NO_CHECK for IPv6
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Organization: Core
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKIEFLIGAC.davids@webmaster.com>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1Ivo4H-0006Z2-00@gondolin.me.apana.org.au>
Date: Sat, 24 Nov 2007 14:00:41 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz <davids@webmaster.com> wrote:
> 
>> Regardless of whatever verifications your application is doing
>> on the data, it is not checksumming the ports and that's what
>> the pseudo-header is helping with.
> 
> So what? We are in the case where the data has already gotten to him. If it
> got to him in error, he'll reject it anyway. The receive checksum check will
> only reject packets that he would reject anyway. That makes it needless.

What if it goes to the wrong recipient who doesn't have the upper-
level checksums?

This is the whole point, IPv6 unlike IPv4 does not have IP header
checksums so the high-level needs to protect it by checksumming
the pseudo-header.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
