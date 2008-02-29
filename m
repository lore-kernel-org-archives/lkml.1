Return-Path: <linux-kernel-owner+w=401wt.eu-S1761241AbYB2SQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761241AbYB2SQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYB2SQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:16:07 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:47919 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753094AbYB2SQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:16:06 -0500
Date: Sat, 1 Mar 2008 02:15:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ritesh Raj Sarraf <rrs@researchut.com>,
       Christophe Saout <christophe@saout.de>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com
Subject: Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in dm-crypt
Message-ID: <20080229181551.GA28193@gondor.apana.org.au>
References: <200802281924.03996.rrs@researchut.com> <20080228232048.51e28c1d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228232048.51e28c1d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 11:20:48PM -0800, Andrew Morton wrote:
>
> Now, I'm assuming that it's just unreasonable for a machine to spend a full
> 11 seconds crunching away on crypto in that code path.  Maybe it _is_
> reasonable, and all we need to do is to poke a cond_resched() in there
> somewhere.  Herbert, any thoughts?  What's the speed of that code?

It encryps 512 bytes each time so it should definitely be pretty
quick.  Perhaps the caller is disabling interrupts or something?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
