Return-Path: <linux-kernel-owner+w=401wt.eu-S1760910AbYDXRc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910AbYDXRc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 13:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbYDXRcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 13:32:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbYDXRcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 13:32:18 -0400
Message-ID: <4810C3F1.9060009@redhat.com>
Date: Thu, 24 Apr 2008 10:31:29 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Michael Kerrisk <mtk.manpages@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org,
       "akpm@linux-foundation.org Jakub Jelinek" <jakub@redhat.com>
Subject: Re: [PATCH] alternative to sys_indirect, part 1
References: <200804240403.m3O43us8028699@devserv.devel.redhat.com>	 <20080424112514.055d8071@the-village.bc.nu>	 <alpine.LFD.1.10.0804240828100.2779@woody.linux-foundation.org>	 <20080424.083908.147395158.davem@davemloft.net>	 <517f3f820804240903y788102bar5c7d1fa9bcee1c8a@mail.gmail.com>	 <20080424164226.415cedeb@the-village.bc.nu> <517f3f820804240948u788745f4s7a5dd4e7417ffeaf@mail.gmail.com> <4810C16A.3000606@zytor.com>
In-Reply-To: <4810C16A.3000606@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

H. Peter Anvin wrote:
> sys_indirect is a total red herring here, since it won't help one iota
> making the userspace interface comprehensible - it just introduces a
> different calling convention that the C library will have to thunk.

Nobody ever suggested that sys_indirect is in any way visible at the
userlevel.  It's only meant to solve the problem of changing many
syscalls (and hence touch lots of arch-specific code).  Again, as said
several times, it could easily be used to fix the existing signalfd and
eventfd syscalls without any arch-specific changes and no userlevel
interface changes (the latter since we already have the correct interface).

Yes, you don't like sys_indirect, we know it.  But don't deliberately
misrepresent the approach.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIEMPx2ijCOnn/RHQRAr7uAJ0aHkZ+bbjk2nsMhhN2xzslA/yhKgCghi8r
9PZw8zfW5fxTVTfrbsHIII0=
=SmAT
-----END PGP SIGNATURE-----
