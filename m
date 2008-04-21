Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYDUGbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYDUGbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 02:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbYDUGbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 02:31:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbYDUGbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 02:31:05 -0400
Message-ID: <480C33E2.7060101@redhat.com>
Date: Sun, 20 Apr 2008 23:27:46 -0700
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080407)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: kernel list <linux-kernel@vger.kernel.org>
Subject: sys_indirect or many syscalls?
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linux,

will you please make a decision regarding sys_indirect?  There has been
no other proposal so the alternative is to add more syscalls.

This really is a problem.  For one instance, see

  http://bugzilla.redhat.com/show_bug.cgi?id=443321

The problem is actually a socket call and we cannot reliably set the
CLOEXEC bit without massive program slowdowns.  This is just one example.

I still think the sys_indirect method is the best since it avoids bloat
in the number of system calls.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkgMM+IACgkQ2ijCOnn/RHRwiQCfXzlb3ihLjJTfgEXIK9BObyvx
H6oAoJBRj4c8lfePA8+GWzRzJXSdss95
=pnY+
-----END PGP SIGNATURE-----
