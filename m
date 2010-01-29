Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655Ab0A2ItL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab0A2ItL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 03:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679Ab0A2ItK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 03:49:10 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:41161 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753226Ab0A2ItK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 03:49:10 -0500
Date: Fri, 29 Jan 2010 21:48:50 +1300
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Matt Mackall <mpm@selenic.com>
Cc: dedekind1@gmail.com, Jeff Angielski <jeff@theptrgroup.com>,
       linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: UBIFS assert failed in ubifs_dirty_inode
Message-ID: <20100129084850.GA23140@gondor.apana.org.au>
References: <4B591573.60602@theptrgroup.com> <1264480808.2401.78.camel@localhost.localdomain> <1264484928.3536.1017.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264484928.3536.1017.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 11:48:48PM -0600, Matt Mackall wrote:
>
> random: drop weird m_time/a_time manipulation
> 
> No other driver does anything remotely like this that I know of except
> for the tty drivers, and I can't see any reason for random/urandom to do
> it. In fact, it's a (trivial, harmless) timing information leak. And
> obviously, it generates power- and flash-cycle wasting I/O, especially
> if combined with something like hwrngd. Also, it breaks ubifs's
> expectations.
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>

Thanks Matt, I'll add this to crypto-2.6 and then stable.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
