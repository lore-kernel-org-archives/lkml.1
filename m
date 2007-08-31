Return-Path: <linux-kernel-owner+w=401wt.eu-S1761183AbXHaEid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761183AbXHaEid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 00:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbXHaEiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 00:38:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54835 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664AbXHaEiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 00:38:22 -0400
Date: Thu, 30 Aug 2007 21:38:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
cc: Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: RE: recent nfs change causes autofs regression
In-Reply-To: <1188534682.6626.70.camel@heimdal.trondhjem.org>
Message-ID: <alpine.LFD.0.999.0708302134500.25853@woody.linux-foundation.org>
References: <000701c7eb49$cff701c0$6fe50540$@com>  <1188513433.6626.24.camel@heimdal.trondhjem.org>
  <001001c7eb57$afd2d320$0f787960$@com>  <1188516173.6626.46.camel@heimdal.trondhjem.org>
  <001501c7eb5d$d295d870$77c18950$@com>  <1188517070.6626.54.camel@heimdal.trondhjem.org>
  <001601c7eb5f$b6146980$223d3c80$@com>
 <1188534682.6626.70.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 31 Aug 2007, Trond Myklebust wrote:
> 
> No. Solaris defaults to breaking cache consistency.

If so, and since that's obviously what people _expect_ to happen, why not 
make that the default, with the "consistent" behaviour being the one that 
needs an explicit option.

Just out of curiosity - Hua, is this NFSv2? Especially there, cache 
"consistency" is largely a joke anyway, so defaulting to some annoying 
careful mode is doubly ridiculous.

		Linus
