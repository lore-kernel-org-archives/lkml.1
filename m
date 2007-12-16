Return-Path: <linux-kernel-owner+w=401wt.eu-S1760919AbXLPIT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760919AbXLPIT5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 03:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754988AbXLPITr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 03:19:47 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3917 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754696AbXLPITq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 03:19:46 -0500
Date: Sun, 16 Dec 2007 16:19:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miles Lane <miles.lane@gmail.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Fw: [PACKET]: Fix /proc/net/packet crash due to bogus private pointer
Message-ID: <20071216081936.GA3042@gondor.apana.org.au>
References: <20071215203637.179878aa.akpm@linux-foundation.org> <a44ae5cd0712152237y2f6a17fcu6a718757c7c021a3@mail.gmail.com> <20071215235604.1a3f970a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071215235604.1a3f970a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2007 at 11:56:04PM -0800, Andrew Morton wrote:
> On Sun, 16 Dec 2007 01:37:01 -0500 "Miles Lane" <miles.lane@gmail.com> wrote:
> 
> > > On Sun, Dec 16, 2007 at 11:07:07AM +0800, Herbert Xu wrote:

So I posted this patch after 19:00 PST on 15 Dec.

> > Dec 15 13:44:39 syntropy kernel:  #0:  (&p->lock){--..}, at:
> > [crypto_algapi:seq_read+0x25/0x191c1] seq_read+0x25/0x26f
> 
> So your kernel is still feeding garbage into lockdep.
> 
> Are you really really sure that kernel had Herbert's patch applied?

The above log message is stamped as 13:44 PST.  I gotta say
this doesn't look good :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
