Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752843AbYLRBfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbYLRBfs (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 20:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790AbYLRBfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 20:35:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:56642 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbYLRBfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 20:35:37 -0500
Subject: Re: [4/7] dst: thread pool.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
In-Reply-To: <20081217233203.GA30039@ioremap.net>
References: <1229521998-7870-1-git-send-email-zbr@ioremap.net>
	 <1229521998-7870-4-git-send-email-zbr@ioremap.net>
	 <1229521998-7870-5-git-send-email-zbr@ioremap.net>
	 <200812171655.05020.arnd@arndb.de> <1229544192.16253.37.camel@pasglop>
	 <20081217233203.GA30039@ioremap.net>
Content-Type: text/plain
Date: Thu, 18 Dec 2008 11:51:47 +1100
Message-Id: <1229561507.19360.0.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I have no objections against any implementation which will be imported
> into the tree and can change the code to use new API quickly, but since
> there is no code right now, I created my own thread pool.

Heh. I think I counted 3 or 4 thread pool implementations already in the
kernel though they are all ad-hoc attached to a given subsystem.

> Particulary DST needs ability to sleep or queue the work to be processed
> by the pool and API to flush/destroy the pool.

Cheers,
Ben.

