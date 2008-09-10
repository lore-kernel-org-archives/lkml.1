Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbYIJXmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbYIJXmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 19:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYIJXm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 19:42:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39247
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752038AbYIJXm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 19:42:27 -0400
Date: Wed, 10 Sep 2008 16:42:20 -0700 (PDT)
Message-Id: <20080910.164220.56492718.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: jeffm@suse.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
From: David Miller <davem@davemloft.net>
In-Reply-To: <1221089816.13621.61.camel@macbook.infradead.org>
References: <1221088512.13621.58.camel@macbook.infradead.org>
	<20080910.162423.40167601.davem@davemloft.net>
	<1221089816.13621.61.camel@macbook.infradead.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Wed, 10 Sep 2008 16:36:56 -0700

> On Wed, 2008-09-10 at 16:24 -0700, David Miller wrote:
> > From: David Woodhouse <dwmw2@infradead.org>
> > Date: Wed, 10 Sep 2008 16:15:11 -0700
> > 
> > > It's definitely not something we should be doing upstream though.
> > 
> > So you think it's ok that every Debian user has to learn this
> > magic incantation just to use current kernels?
> 
> They don't. Debian uses firmware from /lib/firmware if it doesn't exist
> in /lib/firmware/$(version) -- so they can install to the normal
> location quite happily, and it should work just fine.

That's not what I've heard from people more clueful from me.

For example, Herbert Xu (CC:'d) told me that because of this directory
usage, his wireless card couldn't find it's firmware with current
kernels.
