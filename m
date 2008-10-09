Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbYJIUxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbYJIUxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 16:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYJIUxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 16:53:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47513 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbYJIUxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 16:53:02 -0400
Message-ID: <48EE6F22.5070306@redhat.com>
Date: Thu, 09 Oct 2008 13:52:50 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: mtk.manpages@gmail.com, Al Viro <viro@zeniv.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: dup2() vs dup3() inconsistency when
References: <cfd18e0f0810090510i87f088fi9eeea829ae2b58c1@mail.gmail.com> <48EE3D84.6000003@zytor.com> <48EE6A2B.8030005@redhat.com> <48EE6CD6.10007@zytor.com>
In-Reply-To: <48EE6CD6.10007@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

H. Peter Anvin wrote:
> The result of dup3(fd, fd, O_CLOEXEC) is to set the O_CLOEXEC flag on fd.

That's bad and disregarded by Al and myself because it is one and the
same descriptor and therefore it changes the source descriptor.


> Step (2) could be considered a bit dubious, but the behaviour of
> dup2(fd, fd) is a direct consequence of the chosen semantics.

The behavior of dup2(fd,fd) is just a result of an accident in the
original implementation.  It makes no sense and the mistake doesn't have
to be repeated.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjubyIACgkQ2ijCOnn/RHRIMwCfdFeW08lSPRh12C+qKzF99AWf
idEAn0x0jqcVEIzmcgIVuZLlHKleNmC0
=Dx/d
-----END PGP SIGNATURE-----
