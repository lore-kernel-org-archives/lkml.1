Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbYJIA5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbYJIA5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 20:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbYJIA5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 20:57:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43505 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbYJIA5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 20:57:43 -0400
Subject: Re: mISDN didn't define af_family_key_strings et al.
From: Eric Paris <eparis@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081008.172857.189321725.davem@davemloft.net>
References: <1223512049.2952.8.camel@localhost.localdomain>
	 <20081008.172857.189321725.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 20:57:34 -0400
Message-Id: <1223513854.2952.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-08 at 17:28 -0700, David Miller wrote:
> From: Eric Paris <eparis@redhat.com>
> Date: Wed, 08 Oct 2008 20:27:29 -0400
> 
> > I see that recently AF_ISDN was added to the kernel but I don't see them
> > having updated af_family_key_strings[] found in net/core/sock.c.  I'm
> > adding a new one myself and caught a NULL entry toward the end of the
> > array.  My assumption is that isdn is using the sk_lock-AF_MAX entry
> > instead of their own.
> 
> This has been fixed in net-next-2.6 for a few weeks.
> 
> net/core/sock.c:
>   "sk_lock-AF_RXRPC" , "sk_lock-AF_ISDN"     , "sk_lock-AF_PHONET"   ,

Thanks dave.  Didn't see it in Linus's or the ISDN trees.  Didn't even
think to look in net-next....

-Eric

