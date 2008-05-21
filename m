Return-Path: <linux-kernel-owner+w=401wt.eu-S936014AbYEURFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936014AbYEURFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935863AbYEURFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:05:05 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:15179 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935789AbYEURFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:05:04 -0400
Subject: Re: [PATCH] Introduce down_nowait()
From: Daniel Walker <dwalker@mvista.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>
In-Reply-To: <200805211756.04731.rusty@rustcorp.com.au>
References: <200805211600.16415.rusty@rustcorp.com.au>
	 <20080520232903.6756b1c1.akpm@linux-foundation.org>
	 <200805211756.04731.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Wed, 21 May 2008 10:04:58 -0700
Message-Id: <1211389499.18130.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-21 at 17:56 +1000, Rusty Russell wrote:


> Subject: [PATCH] Introduce down_try()
> 
> I planned on removing the much-disliked down_trylock() (with its
> backwards return codes) in 2.6.27, but it's creating something of a
> logjam with other patches in -mm and linux-next.
> 
> Andrew suggested introducing "down_try" as a wrapper now, to make
> the transition easier.

I must be missing something critical, but what's the logjam this is
causing?

Daniel

