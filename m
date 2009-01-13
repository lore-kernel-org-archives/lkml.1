Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZAMGgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZAMGgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 01:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbZAMGgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 01:36:12 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:38526 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750825AbZAMGgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 01:36:11 -0500
Date: Tue, 13 Jan 2009 17:35:53 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: smfrench@gmail.com
Cc: randy.dunlap@oracle.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, sfrench@samba.org, gregkh@suse.de
Subject: Re: linux-next: Tree for January 12 (cifs vs. staging)
Message-ID: <20090113063553.GA26096@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve French <smfrench@gmail.com> wrote:
> There is not just the cifs md5 one (which has been around a long
> time), but an md5_init (static) in crypto and the new one in rt.  The
> addition of the new one (rt md5_init) causes the build problem.   It
> would be nice if we could use the same md5 routines though ... last
> time we checked the crypto one was not well suited for calculating
> signatures as a network fs would do though.

There is no longer any reason to have a custom md5 now that we
have the new crypto_shash interface.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
