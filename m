Return-Path: <linux-kernel-owner+w=401wt.eu-S1755065AbXLAT3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbXLAT3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 14:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbXLAT2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 14:28:48 -0500
Received: from lixom.net ([66.141.50.11]:34606 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbXLAT2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 14:28:46 -0500
Date: Sat, 1 Dec 2007 13:32:21 -0600
From: Olof Johansson <olof@lixom.net>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       apw@shadowen.org, balbir@linux.vnet.ibm.com,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] 2.6.24-rc3-mm2 build failure pasemi-rng driver
Message-ID: <20071201193221.GA27505@lixom.net>
References: <20071128034140.648383f0.akpm@linux-foundation.org> <20071128142201.GA487@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128142201.GA487@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 07:52:01PM +0530, Kamalesh Babulal wrote:
> Hi Andrew,
> 
> The kerne build fails, with message
> 
>   CC      drivers/char/hw_random/pasemi-rng.o
> drivers/char/hw_random/pasemi-rng.c: In function ???pasemi_rng_data_present???:
> drivers/char/hw_random/pasemi-rng.c:53: error: ???wait??? undeclared (first use in this function)
> drivers/char/hw_random/pasemi-rng.c:53: error: (Each undeclared identifier is reported only once
> drivers/char/hw_random/pasemi-rng.c:53: error: for each function it appears in.)
> drivers/char/hw_random/pasemi-rng.c: At top level:
> drivers/char/hw_random/pasemi-rng.c:93: warning: initialization from incompatible pointer type
> make[3]: *** [drivers/char/hw_random/pasemi-rng.o] Error 1
> make[2]: *** [drivers/char/hw_random] Error 2
> make[1]: *** [drivers/char] Error 2
> make: *** [drivers] Error 2
> 
> Tested for build failure, only.

Fix works. Sorry for the delay, it's been a crazy week with other stuff.

> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Acked-by: Olof Johansson <olof@lixom.net>
