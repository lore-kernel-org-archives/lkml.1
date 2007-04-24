Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbXDXBqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbXDXBqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 21:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbXDXBqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 21:46:15 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4530 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754552AbXDXBqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 21:46:15 -0400
Date: Tue, 24 Apr 2007 11:45:28 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Subject: Re: [PATCH 22/25] xen: xen-netfront: use skb.cb for storing private data
Message-ID: <20070424014528.GA27789@gondor.apana.org.au>
References: <20070423215638.563901986@goop.org> <20070423215713.550883195@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423215713.550883195@goop.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 02:57:00PM -0700, Jeremy Fitzhardinge wrote:
> Netfront's use of nh.raw and h.raw for storing page+offset is a bit
> hinky, and it breaks with upcoming network stack updates which reduce
> these fields to sub-pointer sizes.  Fortunately, skb offers the "cb"
> field specifically for stashing this kind of info, so use it.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Chris Wright <chrisw@sous-sol.org>
> Cc: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>

Thanks Jeremy.  The patch looks good.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
