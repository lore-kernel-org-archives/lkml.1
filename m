Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbZFYGNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbZFYGNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 02:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750775AbZFYGNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 02:13:49 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:60341 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750731AbZFYGNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 02:13:48 -0400
Date: Thu, 25 Jun 2009 14:13:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: david@lang.hm
Cc: alex@digriz.org.uk, linux-kernel@vger.kernel.org
Subject: Re: When does Linux drop UDP packets?
Message-ID: <20090625061348.GA31407@gondor.apana.org.au>
References: <20090625050052.GA30594@gondor.apana.org.au> <alpine.DEB.1.10.0906242236400.28437@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906242236400.28437@asgard.lang.hm>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 10:37:14PM -0700, david@lang.hm wrote:
>
> please explain more? how do they differ?

An IGMP-snooping switch will only forward multicast traffic to
ports that have subscribed to that group.  Broadcast traffic
on the otherhand is forwarded to all ports.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
