Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbYJIVE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbYJIVE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 17:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbYJIVEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 17:04:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35606 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbYJIVEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 17:04:20 -0400
Message-ID: <48EE71D0.6090300@redhat.com>
Date: Thu, 09 Oct 2008 14:04:16 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: mtk.manpages@gmail.com, Al Viro <viro@zeniv.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: dup2() vs dup3() inconsistency when
References: <cfd18e0f0810090510i87f088fi9eeea829ae2b58c1@mail.gmail.com> <48EE3D84.6000003@zytor.com> <48EE6A2B.8030005@redhat.com> <48EE6CD6.10007@zytor.com> <48EE6F22.5070306@redhat.com> <48EE703C.7070901@zytor.com>
In-Reply-To: <48EE703C.7070901@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

H. Peter Anvin wrote:
> Inconsistency is bad, too, and one could *definitely* argue that the
> fundamental problem is the one of closing a pre-existing descriptor
> rather than forcing the user to do that explicitly if that behaviour was
> desired.

This is a new interface.  It's not breaking any code and fixing problems
with older interfaces is exactly what you do in such situations.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjucdAACgkQ2ijCOnn/RHQJ2gCgm3vuOgcPJPl3RgdehydbQjkc
2BgAoIM8KBKh94ge2IVBVmqknWs4hwEk
=2KCr
-----END PGP SIGNATURE-----
