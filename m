Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbYBMAiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbYBMAiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYBMAiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:38:14 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56600 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589AbYBMAiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:38:13 -0500
Date: Tue, 12 Feb 2008 16:37:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-Id: <20080212163742.c9e778e6.akpm@linux-foundation.org>
In-Reply-To: <20080212.155853.193190548.davem@davemloft.net>
References: <20080211211751.3e265754@laptopd505.fenrus.org>
	<20080211.221126.230471463.davem@davemloft.net>
	<47B1CB08.4020101@garzik.org>
	<20080212.155853.193190548.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 15:58:53 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> But right now I have to redo the include/linux/rcupdate.h that's in
> there because it has a bug.

Well there's a case in point.  rcupdate.h is not a part of networking, and
it is random tree-wandering like this which causes me problems and which
will cause Stephen problems.

Now, I don't know which tree "owns" rcupdate.h but it ain't networking. 
Probably git-sched.

Nothing in networking depends upon that change (which has a typo in the
comment, btw) hence it can and should have gone through
whichever-tree-owns-that-file.

For Stephen's sake: please.
