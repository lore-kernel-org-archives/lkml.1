Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbYDXQiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbYDXQiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbYDXQiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:38:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbYDXQiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:38:04 -0400
Message-ID: <4810B75B.20202@redhat.com>
Date: Thu, 24 Apr 2008 09:37:47 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] alternative^2 to sys_indirect: socket, socketpair
References: <200804241618.m3OGI9kd013025@devserv.devel.redhat.com> <20080424170325.569afa43@the-village.bc.nu>
In-Reply-To: <20080424170325.569afa43@the-village.bc.nu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Alan Cox wrote:

>> -int sock_map_fd(struct socket *sock)
>> +static int sock_map_fd_flags(struct socket *sock, int flags)

sock_map_fd is exported to modules.  Isn't it a big no-no to change
those interfaces?

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIELda2ijCOnn/RHQRAoXZAKCAnv7JAup2v6KukBp59LDELfNUeACgvuET
eBYx7ErX8E27VLxlYOdeXjs=
=D+sf
-----END PGP SIGNATURE-----
