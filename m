Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbYIPOOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbYIPOOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 10:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbYIPOOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 10:14:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38551 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbYIPOOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 10:14:32 -0400
Message-ID: <48CFBE51.1060200@redhat.com>
Date: Tue, 16 Sep 2008 07:10:25 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] linux/inotify.h: do not include <linux/fcntl.h> in	userspace
References: <1221567763-17060-1-git-send-email-kirill@shutemov.name> <20080916125802.GA15951@cs181140183.pp.htv.fi> <20080916130234.GA17082@localhost.localdomain>
In-Reply-To: <20080916130234.GA17082@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Kirill A. Shutemov wrote:
>> What is the error message?
> 
> /usr/include/asm-generic/fcntl.h:117: error: redefinition of 'struct
> flock'

And?  None of these programs should use <linux/inotify.h>.  There has
for the longest time been a <sys/inotify.h> header which doesn't need
any kernel headers.  In fact, <linux/inotify.h> should not be exported.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjPvlEACgkQ2ijCOnn/RHTO0ACfR2NrTZ97pK34xZKM5pzlRbL6
Nb4AoJ27y9MU+Udr50GZVfZZXjg3ENWg
=7Pol
-----END PGP SIGNATURE-----
