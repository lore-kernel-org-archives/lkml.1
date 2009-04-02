Return-Path: <linux-kernel-owner+w=401wt.eu-S935545AbZDBJRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935545AbZDBJRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935109AbZDBJRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:17:04 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:58580 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935512AbZDBJRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:17:00 -0400
Date: Thu, 2 Apr 2009 17:16:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Avi Kivity <avi@redhat.com>
Cc: ghaskins@novell.com, anthony@codemonkey.ws, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
Message-ID: <20090402091639.GA30126@gondor.apana.org.au>
References: <20090402085253.GA29932@gondor.apana.org.au> <49D47F11.6070400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D47F11.6070400@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 12:02:09PM +0300, Avi Kivity wrote:
>
> There is no choice.  Exiting from the guest to the kernel to userspace  
> is prohibitively expensive, you can't do that on every packet.

I was referring to the bit between the kernel and userspace.

In any case, I just looked at the virtio mitigation code again
and I am completely baffled at why we need it.  Look at Greg's
code or the netback/netfront notification, why do we need this
completely artificial mitigation when the ring itself provides
a natural way of stemming the flow?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
