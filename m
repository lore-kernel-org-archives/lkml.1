Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752201AbYLRIKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbYLRIKm (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 03:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbYLRIKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 03:10:32 -0500
Received: from netgear.net.ru ([195.178.208.66]:37883 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbYLRIKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 03:10:31 -0500
Date: Thu, 18 Dec 2008 11:10:29 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [4/7] dst: thread pool.
Message-ID: <20081218081029.GA20336@ioremap.net>
References: <1229521998-7870-1-git-send-email-zbr@ioremap.net> <1229521998-7870-4-git-send-email-zbr@ioremap.net> <1229521998-7870-5-git-send-email-zbr@ioremap.net> <200812171655.05020.arnd@arndb.de> <1229544192.16253.37.camel@pasglop> <20081217233203.GA30039@ioremap.net> <1229561507.19360.0.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229561507.19360.0.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben.

On Thu, Dec 18, 2008 at 11:51:47AM +1100, Benjamin Herrenschmidt (benh@kernel.crashing.org) wrote:
> Heh. I think I counted 3 or 4 thread pool implementations already in the
> kernel though they are all ad-hoc attached to a given subsystem.

That's how such projects are implemented: when developers need to
extend some other sybsystem they do that with own implementation of the
needed feature. Moreover people frequently argue against importing some
new feature if there are no direct users of it (like may happen with
thread pools, which no one will use immediately), so why bother with
that crap (och, well, and interfaces, there will be definitely people
who do not like them) when it is possible just to make working what
you like? So I fully understand those who implemented it in theirs
subsystems. I would even call blaming them for not pushing theirs
implementations into generic location somewhat hypocritically because
of above :)

-- 
	Evgeniy Polyakov
