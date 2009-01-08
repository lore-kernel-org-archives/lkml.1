Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbZAHMJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbZAHMJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbZAHMJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:09:06 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:51081 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754269AbZAHMJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:09:03 -0500
Date: Thu, 8 Jan 2009 23:08:50 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: michael@laptop.org
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: RFC: Network privilege separation.
Message-ID: <20090108120850.GA3188@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Stone <michael@laptop.org> wrote:
> 
> In short, I'm trying to provide a general-purpose facility for
> 
>   * limiting networking per _process_, not per user, 

You do realise that this is trivial to get around with ptrace,
right? So you'll need to stop ptrace as well.  Then you'll have
to think about all the other ways the process can escape this
networking jail because processes belonging to the same user
just aren't designed to be separated from each other.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
