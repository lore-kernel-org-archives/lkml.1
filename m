Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbXKZOkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbXKZOkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 09:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbXKZOjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 09:39:52 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:2976 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752654AbXKZOjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 09:39:51 -0500
Date: Mon, 26 Nov 2007 22:39:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Denis Cheng <crquan@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 1/2] crypto test: use print_hex_dump from <linux/kernel.h>
Message-ID: <20071126143939.GB28022@gondor.apana.org.au>
References: <1196061182-6368-1-git-send-email-crquan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196061182-6368-1-git-send-email-crquan@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 03:13:02PM +0800, Denis Cheng wrote:
> these utilities implemented in lib/hexdump.c are more handy, please use this.
> 
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Denis Cheng <crquan@gmail.com>

OK this is pretty nice.  But you just missed out because the
GCM patches that just went in added more hexdump uses :)

So could you please refresh your patch against the latest cryptodev
tree? Please also clamp those long lines to 80 characters.

On an unrelated note, lib/hexdump.c should not print 8-bit text
even though they pass the is_print test.  They just turn up as
crap on Unicode terminals.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
