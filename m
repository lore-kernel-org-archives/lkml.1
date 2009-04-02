Return-Path: <linux-kernel-owner+w=401wt.eu-S1765996AbZDBRGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765996AbZDBRGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760294AbZDBRGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:06:32 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:42463 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760140AbZDBRGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:06:31 -0400
Date: Fri, 3 Apr 2009 01:06:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Avi Kivity <avi@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>, anthony@codemonkey.ws,
       andi@firstfloor.org, linux-kernel@vger.kernel.org, agraf@suse.de,
       pmullaney@novell.com, pmorreale@novell.com, netdev@vger.kernel.org,
       kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 00/17] virtual-bus
Message-ID: <20090402170610.GA3001@gondor.apana.org.au>
References: <49D49C1F.6030306@novell.com> <200904022243.21088.rusty@rustcorp.com.au> <49D4B4A3.5070008@novell.com> <49D4B87D.2000202@redhat.com> <20090402145018.GA816@gondor.apana.org.au> <49D4D301.2090209@redhat.com> <20090402154041.GA1774@gondor.apana.org.au> <49D4E072.2060003@redhat.com> <20090402160941.GB2173@gondor.apana.org.au> <49D4EDBD.3050900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D4EDBD.3050900@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 07:54:21PM +0300, Avi Kivity wrote:
>
> 3ms latency for ping?
>
> (ping will always be scheduled immediately when the reply arrives if I  
> understand cfs, so guest load won't delay it)

That only happens if the guest immediately does some CPU-intensive
computation 3ms and assuming its timeslice lasts that long.

In any case, the same thing will happen right now if the host or
some other guest on the same CPU hogs the CPU for 3ms.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
