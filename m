Return-Path: <linux-kernel-owner+w=401wt.eu-S1752426AbXLDD6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbXLDD6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 22:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbXLDD62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 22:58:28 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:4093 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751326AbXLDD61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 22:58:27 -0500
Date: Tue, 4 Dec 2007 14:57:55 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wang Chen <wangchen@cn.fujitsu.com>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Gerrit Renker <gerrit@erg.abdn.ac.uk>, davem@davemloft.net,
       andi@firstfloor.org, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] [UDP6]: Counter increment on BH mode
Message-ID: <20071204035755.GA32263@gondor.apana.org.au>
References: <474F7EE8.2040009@cn.fujitsu.com> <474F8255.5060501@cn.fujitsu.com> <20071130111949.GB28277@gerrit.erg.abdn.ac.uk> <20071201015438.GC26895@gondor.apana.org.au> <4753AE07.1040906@cn.fujitsu.com> <20071203113935.GA25124@gondor.apana.org.au> <20071203114912.GA4425@ms2.inr.ac.ru> <20071203115435.GA4202@gondor.apana.org.au> <20071203131723.GA30312@gondor.apana.org.au> <4754CE9F.3060506@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4754CE9F.3060506@cn.fujitsu.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 11:50:55AM +0800, Wang Chen wrote:
>
> >  #include <linux/cache.h>
> >  #include <linux/snmp.h>
> > +#include <linux/smp.h>
> 
> It's no need to include smp.h?

We need it for smp_processor_id.  Well we needed it before too but
there's probably some implicit inclusion which has made it work.
It's better to declare these inclusions explicitly as otherwise
they may break on less common architectures later.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
