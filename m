Return-Path: <linux-kernel-owner+w=401wt.eu-S1761828AbXGJKFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761828AbXGJKFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 06:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757457AbXGJKFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 06:05:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60923 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756268AbXGJKFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 06:05:33 -0400
Date: Tue, 10 Jul 2007 03:04:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: netdev@vger.kernel.org, ebiederm@xmission.com, viro@ftp.linux.org.uk,
       alan@lxorguk.ukuu.org.uk, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH re-resend] fix race in AF_UNIX garbage collector
Message-Id: <20070710030443.f2deaab6.akpm@linux-foundation.org>
In-Reply-To: <E1I8CMY-00053l-00@dorka.pomaz.szeredi.hu>
References: <E1I8CMY-00053l-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 11:50:30 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:

> Can you please add this to -mm.  Sometimes that has wonderful effect
> on the willingness of people to look at a patch.

sure ;)

> It fixes a bug in AF_UNIX sockets that affects the ulockmgr library in
> the fuse package.  And for some reason it doesn't seem to interest the
> netdev guys in the least.

heh.  Maybe it's time to swap the MM and net development teams around.  Things
have been getting a bit dull around here lately.
