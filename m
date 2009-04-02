Return-Path: <linux-kernel-owner+w=401wt.eu-S1765918AbZDBJd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765918AbZDBJd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbZDBJdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:33:43 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:33183 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753426AbZDBJdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:33:42 -0400
Date: Thu, 2 Apr 2009 17:33:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Avi Kivity <avi@redhat.com>
Cc: ghaskins@novell.com, anthony@codemonkey.ws, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org, Patrick Ohly <patrick.ohly@intel.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH 00/17] virtual-bus
Message-ID: <20090402093324.GA30397@gondor.apana.org.au>
References: <20090402085253.GA29932@gondor.apana.org.au> <49D47F11.6070400@redhat.com> <20090402091639.GA30126@gondor.apana.org.au> <49D484F5.2000400@redhat.com> <20090402092936.GA30333@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402092936.GA30333@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 05:29:36PM +0800, Herbert Xu wrote:
> On Thu, Apr 02, 2009 at 12:27:17PM +0300, Avi Kivity wrote:
> >
> > If tap told us when the packets were actually transmitted, life would be  
> > wonderful:
> 
> And why do we need this? Because we are in user space!
> 
> I'll continue to wait for your patch and numbers :)

And in case you're working on that patch, this might interest
you.  Check out the netdev thread titled "TX time stamping".
Now that we assign the tap skb with its own sk, these two scenarios
are pretty much identical.

I also noitced despite davem's threats to revert the patch, it
has now made Linus's tree :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
