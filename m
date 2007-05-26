Return-Path: <linux-kernel-owner+w=401wt.eu-S1756634AbXEZLIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbXEZLIl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 07:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbXEZLId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 07:08:33 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2456 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750994AbXEZLIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 07:08:32 -0400
Date: Sat, 26 May 2007 21:08:18 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: software suspend doesn't work with 2.6.22-rc3
Message-ID: <20070526110818.GA7918@gondor.apana.org.au>
References: <200705261128.57332.maxi@daemonizer.de> <1180173233.9773.79.camel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180173233.9773.79.camel@nigel.suspend2.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2007 at 07:53:53PM +1000, Nigel Cunningham wrote:
> 
> Herbert, is this right? If cryptd is going to be used for block devs,
> the task should probably be PF_NOFREEZE (or whatever it is today)
> instead.

Probably.  However, I don't think this is responsible for the reported
problem because the code to use cryptd in dm-crypt hasn't been merged
yet :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
