Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbYEQBCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbYEQBCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 21:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbYEQBBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 21:01:55 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:58600 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752012AbYEQBBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 21:01:54 -0400
Date: Sat, 17 May 2008 09:01:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Chris Peterson <cpeterso@cpeterso.com>,
       tpmdd-devel@lists.sourceforge.net, tpm@selhorst.net
Subject: Re: [PATCH] Re: [PATCH] drivers/net: remove network drivers' last few uses of IRQF_SAMPLE_RANDOM
Message-ID: <20080517010136.GA15102@gondor.apana.org.au>
References: <20080515142154.0595e475@core> <36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com> <20080515173939.1ec968be@core> <482C7DA3.1090809@garzik.org> <482C953A.4080205@garzik.org> <87abirytxj.fsf@basil.nowhere.org> <20080516105635.6cb1f505@core> <482D5FC5.2070103@firstfloor.org> <20080516121239.GA9627@gondor.apana.org.au> <482DB568.1040704@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482DB568.1040704@firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 06:25:12PM +0200, Andi Kleen wrote:
>
> You could do that, but what advantage would it have? I don't think it's
> worth running the FIPS test, or rather requiring the user land daemon
> and leaving behind most of the userbase just for this.

The obvious advantage is that you don't unblock /dev/random readers
until there is real entropy available.

Remember that a hardware RNG failure is a catastrophic event, so
a heavy-handed response such as blocking /dev/random is reasonable.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
