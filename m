Return-Path: <linux-kernel-owner+w=401wt.eu-S1764001AbYD0XeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764001AbYD0XeE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759801AbYD0Xdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:33:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758361AbYD0Xdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:33:53 -0400
Message-ID: <48150D57.5020803@redhat.com>
Date: Sun, 27 Apr 2008 16:33:43 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] eventfd, signalfd, timerfd, epoll_create w/flags
References: <200804272217.m3RMHZ0S021481@devserv.devel.redhat.com> <Pine.LNX.4.64.0804271614240.18184@alien.or.mcafeemobile.com> <48150BDA.5070903@redhat.com> <48150CCE.6050700@zytor.com>
In-Reply-To: <48150CCE.6050700@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

H. Peter Anvin wrote:
> But surely these will have to be exposed to the user level somehow?

You didn't read what I wrote in the first mail.  When I added the
interface to glibc I already added a flags parameter.  It's just not
used yet.  So the userlevel interface will not change at all.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIFQ1X2ijCOnn/RHQRAn+CAJ9gpYMkS7FG7VcJfPeWcMkxCRdsWQCdHZ22
DXkAkO0gyiAV1LbzSOfS6ws=
=Tfpx
-----END PGP SIGNATURE-----
