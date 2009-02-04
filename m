Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbZBDIJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbZBDIJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 03:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbZBDIIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 03:08:54 -0500
Received: from kandzendo.ru ([195.178.208.66]:59125 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbZBDIIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 03:08:54 -0500
Date: Wed, 4 Feb 2009 11:08:51 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Miller <davem@davemloft.net>
Cc: jarkao2@gmail.com, herbert@gondor.apana.org.au, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090204080851.GA10445@ioremap.net>
References: <20090202.235017.253437221.davem@davemloft.net> <20090203094108.GA4639@ff.dom.local> <20090203111012.GA16878@ioremap.net> <20090203.164609.160183741.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203.164609.160183741.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 04:46:09PM -0800, David Miller (davem@davemloft.net) wrote:
> > NTA tried to solve this by not allowing to free the data allocated on
> > the different CPU, contrary to what SLAB does. Modulo cache coherency
> > improvements,
> 
> This could kill performance on NUMA systems if we are not careful.
> 
> If we ever consider NTA seriously, these issues would need to
> be performance tested.

Quite contrary I think. Memory is allocated and freed on the same CPU,
which means on the same memory domain, closest to the CPU in question.

I did not test NUMA though, but NTA performance on the usual CPU (it is
2.5 years old already :) was noticebly good.

-- 
	Evgeniy Polyakov
