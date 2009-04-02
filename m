Return-Path: <linux-kernel-owner+w=401wt.eu-S1763639AbZDBPaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763639AbZDBPaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763193AbZDBP3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:29:45 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:37521 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763478AbZDBP3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:29:44 -0400
Date: Thu, 2 Apr 2009 23:29:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       oliver@neukum.org
Subject: Re: [PATCH 1/2 V3] kaweth: Fix locking to be SMP-safe
Message-ID: <20090402152936.GA1670@gondor.apana.org.au>
References: <20090402100223.GA30905@gondor.apana.org.au> <49D4D37A.50504@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D4D37A.50504@lwfinger.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 10:02:18AM -0500, Larry Finger wrote:
>
> The .ndo_poll_controller callback is left at NULL in this driver. I believe the
> patch to be OK.

Good point!

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
