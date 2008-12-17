Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752145AbYLQUF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbYLQUF1 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 15:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbYLQUFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 15:05:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:44246 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbYLQUFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 15:05:12 -0500
Subject: Re: [4/7] dst: thread pool.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
In-Reply-To: <200812171655.05020.arnd@arndb.de>
References: <1229521998-7870-1-git-send-email-zbr@ioremap.net>
	 <1229521998-7870-4-git-send-email-zbr@ioremap.net>
	 <1229521998-7870-5-git-send-email-zbr@ioremap.net>
	 <200812171655.05020.arnd@arndb.de>
Content-Type: text/plain
Date: Thu, 18 Dec 2008 07:03:12 +1100
Message-Id: <1229544192.16253.37.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Have you looked at the last discussion involving thread pools in Linux?
> BenH brought up the topic earlier this year, it is archived on
> https://lists.linux-foundation.org/pipermail/ksummit-2008-discuss/2008-July/000213.html
> 
> So while it seems that there is clearly a use for such infrastructure,
> my feeling is that it should not be part of dst, but rather live
> in a location where it can be used by every subsystem.
> 
> Of course getting it there means another flame war^W^W discussion about what
> the right interface should look like.
> 
> My personal feeling is that the interface should look a lot like
> the existing work queues, to the point where you can easily convert
> drivers between them, or even move all work queues over to thread pools.

The idea after KS was to use David Howells slow_work, maybe massaging
the interfaces a bit.

I haven't had time to dedicate to that yet myself. David, what are you
up to with your initial implementation ?

Cheers,
Ben.


