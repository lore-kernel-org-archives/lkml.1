Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbXEZLz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbXEZLz3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 07:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbXEZLzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 07:55:22 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2676 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751105AbXEZLzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 07:55:22 -0400
Date: Sat, 26 May 2007 21:55:13 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: software suspend doesn't work with 2.6.22-rc3
Message-ID: <20070526115513.GA8230@gondor.apana.org.au>
References: <200705261128.57332.maxi@daemonizer.de> <1180173233.9773.79.camel@nigel.suspend2.net> <20070526110818.GA7918@gondor.apana.org.au> <1180178040.5493.5.camel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180178040.5493.5.camel@nigel.suspend2.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2007 at 09:14:00PM +1000, Nigel Cunningham wrote:
> 
> You have the cryptd Kconfig option in (at least in rc3) - presumably
> Maximillian has been too keen and turned it on before you were ready :)
> It does make sense for it to be the problem. Without PF_NOFREEZE set,
> the refrigerator code will try to get it to enter the freezer, and
> without the try_to_freeze(), it will just loop and freezing will fail.

OK that makes sense.  I'll apply your patch.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
