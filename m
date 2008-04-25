Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbYDYBlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbYDYBlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 21:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbYDYBk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 21:40:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39549
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753774AbYDYBk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 21:40:57 -0400
Date: Thu, 24 Apr 2008 18:40:51 -0700 (PDT)
Message-Id: <20080424.184051.192887364.davem@davemloft.net>
To: drepper@redhat.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] alternative^2 to sys_indirect: socket, socketpair
From: David Miller <davem@davemloft.net>
In-Reply-To: <4810B75B.20202@redhat.com>
References: <200804241618.m3OGI9kd013025@devserv.devel.redhat.com>
	<20080424170325.569afa43@the-village.bc.nu>
	<4810B75B.20202@redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Drepper <drepper@redhat.com>
Date: Thu, 24 Apr 2008 09:37:47 -0700

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Alan Cox wrote:
> 
> >> -int sock_map_fd(struct socket *sock)
> >> +static int sock_map_fd_flags(struct socket *sock, int flags)
> 
> sock_map_fd is exported to modules.  Isn't it a big no-no to change
> those interfaces?

It's perfectly acceptable to change the interface however
you like when necessary, and merely fix up all the in-tree users.
