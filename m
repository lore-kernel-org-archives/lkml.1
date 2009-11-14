Return-Path: <linux-kernel-owner+w=401wt.eu-S1756974AbZKNCvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbZKNCvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 21:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbZKNCvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 21:51:39 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:43452 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753908AbZKNCvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 21:51:39 -0500
Date: Sat, 14 Nov 2009 10:51:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Gregory Haskins <gregory.haskins@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>,
       "Michael S. Tsirkin" <mst@redhat.com>,
       alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC PATCH] net: add dataref destructor to sk_buff
Message-ID: <20091114025135.GA19289@gondor.apana.org.au>
References: <4AF919020200005A000586A9@sinclair.provo.novell.com> <20091110131722.GA19645@redhat.com> <4AF9747E.8020408@novell.com> <20091110143652.GB19645@redhat.com> <4AF98A8C.9040201@novell.com> <20091114011229.GA18580@gondor.apana.org.au> <4AFE08EF.2030308@gmail.com> <20091114022103.GA19020@gondor.apana.org.au> <4AFE15AD.6000208@gmail.com> <20091113184503.13f6d447@s6510>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113184503.13f6d447@s6510>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 06:45:03PM -0800, Stephen Hemminger wrote:
> 
> No all the interfaces require a copy. Actually, sendfile makes no guarantee about synchronization

Actually sendfile does not require a copy.

> because the receiver of said file could be arbitrarily slow, and any attempt at locking down
> current contents of file is a denial of service exposure.

Agreed.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
