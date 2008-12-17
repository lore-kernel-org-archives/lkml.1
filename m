Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752660AbYLQXjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbYLQXjr (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 18:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbYLQXjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 18:39:37 -0500
Received: from cet.com.ru ([195.178.208.66]:36081 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbYLQXjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 18:39:36 -0500
Date: Thu, 18 Dec 2008 02:39:35 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [4/7] dst: thread pool.
Message-ID: <20081217233934.GB30039@ioremap.net>
References: <1229521998-7870-1-git-send-email-zbr@ioremap.net> <1229521998-7870-4-git-send-email-zbr@ioremap.net> <1229521998-7870-5-git-send-email-zbr@ioremap.net> <200812171655.05020.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812171655.05020.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd.

On Wed, Dec 17, 2008 at 04:55:04PM +0100, Arnd Bergmann (arnd@arndb.de) wrote:
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

As Benjamin said, it was decided to use David Howells work. I hope it
will allow simple usage model DST has, but since there is no code yet, I
have my own.

If David will not push it upstream I think it could be possible to move
DST's thread pool outside of the storage project. I can review any
submitted pool implementation if being copied, but so far will carry own
implementation in the DST sources. If David will not push his code we
can return to my implementation.

-- 
	Evgeniy Polyakov
