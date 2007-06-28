Return-Path: <linux-kernel-owner+w=401wt.eu-S1765768AbXF1V3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765768AbXF1V3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 17:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759655AbXF1V3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 17:29:33 -0400
Received: from barikada.upol.cz ([158.194.242.200]:38455 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759446AbXF1V3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 17:29:33 -0400
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm <akpm@linux-foundation.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] scripts/decodecode: fix for /bin/sh (cc your enemies)
In-Reply-To: <20070628105137.bf5e5607.randy.dunlap@oracle.com>
References: <20070628105137.bf5e5607.randy.dunlap@oracle.com>
Date: Thu, 28 Jun 2007 23:42:24 +0200
Message-Id: <E1I41ku-0007Xd-Kw@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Date: Thu, 28 Jun 2007 10:51:37 -0700

I didn't want to respond to your prev. messages, because i felt, that
they will be mis-read again as my original NAK (ASCII negative
acknowledgement symbol, no other "fsky" meaning inside). Also i wanted
to come up with more nice tool, like colour support (like `ls' or 
`quilt diff'), CROSS toolchains support, nicer sed magic in implementation,
etc.

All this was in my short original comment. Yes that message was short and
somebody even thought i was not so polite -- from my POV that was
concrete description of the bug, with clear goodwill to help. Therefore,
IMNSHO one *must* suppress any personal angriness before replying to
(very simple and small in this case) technical issues.

Now i feel the same as Bartlomiej described in the discussion of regression
tracking, that got even quoted in LWN prev. kernel page [0].

I will not say i'm sad, i will say it's awesome to have so much attention
to silly issues like /bin/sh->/bin/bash. By the way it was Linus who
pointed out *my*, possibly bad, usage of GNU find extensions in the
Makefile near you. After that, i started to check at least busybox's
tools before i will go to GNU's luxury of features. And as you may
noticed, Ubuntu even defaults shell like dash in its setup, while in
Debian i have questions and/or `update-alternatives'.

It's obvious for me now, why that regression tracking thread has ended
without useful implementation ideas or counter-arguments against Debian
BTS....

[0] The Kernel page with link to "Cc those reviwers, who, you think, are
    your enemies" <http://lwn.net/Articles/238283/>

> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Convert substring expressions to be sh-compatible.
>
> Tested by Arne Georg Gleditsch <argggh@dolphinics.no>
____
