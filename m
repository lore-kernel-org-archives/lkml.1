Return-Path: <linux-kernel-owner+w=401wt.eu-S1759797AbYFNVcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797AbYFNVcr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 17:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbYFNVXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 17:23:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:49402 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400AbYFNVXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 17:23:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PES6jt1239e6wHJQUUO8CqYX6xUpy2T4ok7ZR9B9CtcsF6acXNHn+xyU1J0pVtjtfd
         wkRoeoZUSMzFiZ+ouq95kDKcZnnDa/+g1HXAk0Ezaw50xpqxKcq7toOnvCjYdIuIYIFo
         LdYXCos4SyBACTxHr5fwHQB2iv9HPYT4FVMks=
Message-ID: <19f34abd0806141423m18e35f29qb736d44460d70785@mail.gmail.com>
Date: Sat, 14 Jun 2008 23:23:35 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Daniel J Blueman" <daniel.blueman@gmail.com>
Subject: Re: 2.6.26-rc5: SLUB debug, lockdep warning...
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <6278d2220806140354i7f163086i6127664d8c2d88a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220806140354i7f163086i6127664d8c2d88a9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 12:54 PM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
> When enabling lockdep + SLUB debugging, I spotted this recursive
> lock-acquisition warning [1] when booting, however it doesn't always
> pop out.

This seems to be the work of

commit 3ac7fe5a4aab409bd5674d0b070bce97f9d20872
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Wed Apr 30 00:55:01 2008 -0700

    infrastructure to debug (dynamic) objects

...which by the way changed SLUB without any SOBs from any of the SLUB
maintainers?

Anyway, adding some Ccs.

>
> Let me know if you need further information etc.

Exact kernel version and your config file would be useful (please post
it online somewhere if possible). Thanks!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
