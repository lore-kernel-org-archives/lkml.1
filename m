Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbYDXRxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbYDXRxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 13:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbYDXRxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 13:53:24 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33531 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752238AbYDXRxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 13:53:23 -0400
Date: Thu, 24 Apr 2008 18:23:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] alternative^2 to sys_indirect: socket, socketpair
Message-ID: <20080424182352.693f818b@the-village.bc.nu>
In-Reply-To: <4810B75B.20202@redhat.com>
References: <200804241618.m3OGI9kd013025@devserv.devel.redhat.com>
	<20080424170325.569afa43@the-village.bc.nu>
	<4810B75B.20202@redhat.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008 09:37:47 -0700
Ulrich Drepper <drepper@redhat.com> wrote:

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

Upstream no. We just fix the users. The aversion to changing exported
symbols between kernels is strictly an enterprise vendor thing. 

Alan
