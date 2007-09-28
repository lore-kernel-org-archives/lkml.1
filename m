Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbXI1SMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbXI1SMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbXI1SLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:11:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52191 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753785AbXI1SLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:11:52 -0400
Date: Fri, 28 Sep 2007 11:11:07 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: jbeulich@novell.com (Jan Beulich), bridge@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Module use count must be updated as bridges are
 created/destroyed
Message-ID: <20070928111107.57519b67@freepuppy.rosehill>
In-Reply-To: <E1Ib8Xj-0006Kl-00@gondolin.me.apana.org.au>
References: <46FBE2DD.76E4.0078.0@novell.com>
	<E1Ib8Xj-0006Kl-00@gondolin.me.apana.org.au>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 13:37:39 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Jan Beulich <jbeulich@novell.com> wrote:
> >
> > So we have an unsolvable problem here then, unless infrastructure gets added
> > that allows a module to declare itself as not-implicit-unload-safe, forcing
> > modprobe -r to keep its hands off it. Ugly.
> 
> Yes I've always wanted to have a separate count that indicates
> a module is in use but does not prevent its immediate removal.
> 
> Cheers,

It is only the nested removal problem.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
