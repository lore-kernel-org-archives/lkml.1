Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbXKUNnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbXKUNnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 08:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbXKUNnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 08:43:23 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3268 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752564AbXKUNnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 08:43:22 -0500
Date: Wed, 21 Nov 2007 21:42:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: YOSHIFUJI Hideaki / =?utf-8?B?5ZCJ6Jek6Iux5piO?= 
	<yoshfuji@linux-ipv6.org>
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] SO_NO_CHECK for IPv6
Message-ID: <20071121134258.GA30883@gondor.apana.org.au>
References: <20071121124532.GA17263@havoc.gtf.org> <20071121.222051.94402865.yoshfuji@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071121.222051.94402865.yoshfuji@linux-ipv6.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2007 at 01:20:51PM +0000, YOSHIFUJI Hideaki / 吉藤英明 wrote:
> In article <20071121124532.GA17263@havoc.gtf.org> (at Wed, 21 Nov 2007 07:45:32 -0500), Jeff Garzik <jeff@garzik.org> says:
> 
> > 
> > SO_NO_CHECK support for IPv6 appeared to be missing. This is presented,
> > based on a reading of net/ipv4/udp.c.
> 
> Disagree. UDP checksum is mandatory in IPv6.

Right, IPv6 doesn't have a header checksum so the UDP checksum
must be there.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
