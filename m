Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbYEWObx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbYEWObx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 10:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757571AbYEWObj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 10:31:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757222AbYEWObh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 10:31:37 -0400
Message-ID: <4836D52A.5030600@redhat.com>
Date: Fri, 23 May 2008 07:31:06 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 18/18] flag parameters: check magic constants
References: <200805062118.m46LI74j004096@devserv.devel.redhat.com> <20080522222246.0526f8f8.akpm@linux-foundation.org>
In-Reply-To: <20080522222246.0526f8f8.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
> 	BUILD_BUG_ON(SOCK_NONBLOCK != O_NONBLOCK);

After the addition of arch-specific SOCK_NONBLOCK values this line must
go.  I thought one of my patches already did that.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkg21SoACgkQ2ijCOnn/RHQG2wCeNS8o/cVxuOYXRbCnwFTg1rcx
590AoIvJBnwNP9O26kIHNY3ExVTA2M2a
=5P4P
-----END PGP SIGNATURE-----
