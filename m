Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbYGXHnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbYGXHnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 03:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbYGXHnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 03:43:15 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:48688 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751219AbYGXHnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 03:43:14 -0400
Date: Thu, 24 Jul 2008 15:43:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: crypto stuff broken in -mm?
Message-ID: <20080724074306.GA5071@gondor.apana.org.au>
References: <87ljzwh3j3.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ljzwh3j3.fsf@saeurebad.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 05:24:48PM +0000, Johannes Weiner wrote:
> 
> I can not access my encrypted partitions with -mm while they work with
> mainline.
> 
> For both trees I have similar configs, I didn't change anything relative
> to this subsystem:

I can't reproduce this problem here.  I've created an encrypted
volume with 2.6.23 and it still decrypts correctly with the latest
upstream Linux kernel which has all the crypto updates.

So it looks like one of the other patches in mm that's causing
this.  Please try backing out any device mapper related changes
and see if things improve.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
