Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbZA1Lgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbZA1Lgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 06:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbZA1Lgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 06:36:33 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34145 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751258AbZA1Lgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 06:36:32 -0500
Date: Wed, 28 Jan 2009 11:36:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bron Gondwana <brong@fastmail.fm>
Cc: Ray Lee <ray-lk@madrabbit.org>, Davide Libenzi <davidel@xmailserver.org>,
       Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] epoll: increase default max_user_instances to 1024
Message-ID: <20090128113640.2ea5a9fb@lxorguk.ukuu.org.uk>
In-Reply-To: <20090128105902.GB29864@brong.net>
References: <20090128033824.GA1662@brong.net>
	<59410684d947bc68862a4f5d6c2a5bb1f29519ee.1233114169.git.brong@fastmail.fm>
	<alpine.DEB.1.10.0901271949070.20262@alien.or.mcafeemobile.com>
	<2c0942db0901272007w4298738cq37918f776276d424@mail.gmail.com>
	<20090128101641.33978100@lxorguk.ukuu.org.uk>
	<20090128105902.GB29864@brong.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > "A kernel upgrade in a -stable series point release fixed a security DoS"
> 
> Alan, that's a complete load of bollocks.  It broke common configurations 
> of java, postfix and apache on real-world machines, causing significant
> actual denials of service in previously reliable configurations.

It fixed a security DoS. I was merely pointing out that the description
provided before was bogus, incomplete and loaded.

> viable within the code.  The DoS works by creating epoll descriptors
> watching other epoll descriptors, which strikes me as a much less
> real-world actual use pattern than a bunch of separate daemons with an
> epoll watcher each.

Deliberate attackers don't have to follow typical usage patterns.

> If it's possible to count watches only if they're added to another epoll
> instance, then we'd have a metric that still catches the N^2 attack, but
> doesn't interact with the common non-attacky use-case.

Agreed entirely.
