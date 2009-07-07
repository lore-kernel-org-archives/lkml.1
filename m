Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbZGGGZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbZGGGZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 02:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbZGGGZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 02:25:34 -0400
Received: from a.mx.secunet.com ([213.68.205.161]:35971 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbZGGGZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 02:25:34 -0400
Date: Tue, 7 Jul 2009 08:00:15 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Huang Ying <ying.huang@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [RFC 7/7] crypto: Add PCLMULQDQ accelerated GHASH
	implementation
Message-ID: <20090707060015.GA20288@secunet.com>
References: <20090621135121.GA3153@gondor.apana.org.au> <1246937512.5282.99.camel@yhuang-dev.sh.intel.com> <20090707034548.GA28075@gondor.apana.org.au> <20090707040232.GA28257@gondor.apana.org.au> <20090707040341.GA28303@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090707040341.GA28303@gondor.apana.org.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 07 Jul 2009 05:57:38.0221 (UTC) FILETIME=[D4FF2DD0:01C9FEC7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 12:03:41PM +0800, Herbert Xu wrote:
> On Tue, Jul 07, 2009 at 12:02:32PM +0800, Herbert Xu wrote:
> >
> > Actually I'll do the remaining DIGEST algorithms right now because
> > without them hmac can't be converted.
> 
> Nevermind, there aren't any remaining DIGEST algorithms :)
> 
> I'll get onto hmac.
> 

Just FYI, I have a ahash version of hmac. Actually I'm about to convert
the hmac users. I have not posted it so far because not all hmac users
are converted, but I can do so if you are interested.
