Return-Path: <linux-kernel-owner+w=401wt.eu-S1761247AbXJZPpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761247AbXJZPpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759018AbXJZPo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:44:58 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:51200 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbXJZPo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:44:56 -0400
Message-ID: <47220B66.5050002@hp.com>
Date: Fri, 26 Oct 2007 11:44:38 -0400
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] [CRYPTO] users: Fix up scatterlist conversion errors
References: <20071026145905.GA13850@gondor.apana.org.au> <E1IlQfN-0003cW-00@gondolin.me.apana.org.au>
In-Reply-To: <E1IlQfN-0003cW-00@gondolin.me.apana.org.au>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> [CRYPTO] users: Fix up scatterlist conversion errors
> 
> This patch fixes the errors made in the users of the crypto layer during
> the sg_init_table conversion.  It also adds a few conversions that were
> missing altogether.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  drivers/crypto/padlock-sha.c          |    4 +-
>  drivers/md/dm-crypt.c                 |    2 -
>  drivers/net/ppp_mppe.c                |   10 ++++-
>  drivers/scsi/iscsi_tcp.c              |    5 +-
>  fs/ecryptfs/crypto.c                  |    2 +
>  net/ipv4/esp4.c                       |    7 ++-
>  net/ipv6/esp6.c                       |    8 +++-
>  net/rxrpc/rxkad.c                     |   66 +++++++++++++++++-----------------
>  net/sctp/auth.c                       |    3 -
>  net/sctp/sm_make_chunk.c              |    6 +--
>  net/sunrpc/auth_gss/gss_krb5_crypto.c |   34 +++++++++++++----
>  net/sunrpc/auth_gss/gss_spkm3_seal.c  |    2 -
>  net/sunrpc/xdr.c                      |    2 +
>  13 files changed, 93 insertions(+), 58 deletions(-)
> 

Ack SCTP pieces.  I had those queued up, but you got to it before me ;)

Thanks
-vlad

