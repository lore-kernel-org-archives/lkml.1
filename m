Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbZEMOCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbZEMOCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZEMOCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:02:37 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51920 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbZEMOCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:02:36 -0400
Date: Wed, 13 May 2009 10:02:25 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: tcrypt: add option to not exit on success
Message-ID: <20090513140224.GB16406@hmsreliant.think-freely.org>
References: <200905111006.32675.jarod@redhat.com> <20090513110826.GA16406@hmsreliant.think-freely.org> <20090513113819.GA15662@gondor.apana.org.au> <200905130912.46965.jarod@redhat.com> <20090513132752.GA17262@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090513132752.GA17262@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 11:27:52PM +1000, Herbert Xu wrote:
> On Wed, May 13, 2009 at 09:12:46AM -0400, Jarod Wilson wrote:
> > 
> > Hm... FIPS has the requirement that we test all algs before we use any
> > algs, self-tests on demand before first use for each alg is
> > insufficient. At first blush, I'm not seeing how we ensure this
> > happens. How can we trigger a cbc(des3_ede) self-test from userspace?
> > I see that modprobe'ing des.ko runs the base des and des3_ede
> > self-tests, but modprobe'ing cbc.ko doesn't lead to any self-tests
> > being run.
> 
> Once we have a user-space interface crypto API you will be able
> to instantiate any given algorithm.
> 
Thats a good idea.  Jarod, didn't you create a generic netlink socket family
module that created just such an interface for testing purposes?  That might be
worth polishing and submitting to provide that user space crypto api

Neil

> 
