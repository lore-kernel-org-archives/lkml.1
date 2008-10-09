Return-Path: <linux-kernel-owner+w=401wt.eu-S1756115AbYJIUcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbYJIUcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 16:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbYJIUbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 16:31:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56034 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbYJIUby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 16:31:54 -0400
Message-ID: <48EE6A2B.8030005@redhat.com>
Date: Thu, 09 Oct 2008 13:31:39 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: mtk.manpages@gmail.com, Al Viro <viro@zeniv.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: dup2() vs dup3() inconsistency when
References: <cfd18e0f0810090510i87f088fi9eeea829ae2b58c1@mail.gmail.com> <48EE3D84.6000003@zytor.com>
In-Reply-To: <48EE3D84.6000003@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

H. Peter Anvin wrote:
> The dup2() behavior comes from the logical consequence of dup2()'s
> "close on reuse"; one would think it would be logical for dup3() to
> behave the same way.

No.  We deliberately decided on this change.  Otherwise, what is the
result of dup3(fd, fd, O_CLOEXEC)?  There is no reason to use
dup2(fd,fd), so why the hell somebody wants to defend this is beyond me.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjuaisACgkQ2ijCOnn/RHRBBgCeMtzyHtpv7jt5a2XxIq9LEoDN
ZVYAnixMwtW6d6SL55MvrKwV/B5Yv1Cm
=MCqO
-----END PGP SIGNATURE-----
