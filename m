Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbYEaEqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbYEaEqW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 00:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbYEaEqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 00:46:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678AbYEaEqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 00:46:10 -0400
Message-ID: <4840D807.2030406@redhat.com>
Date: Fri, 30 May 2008 21:45:59 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [PATCH 3/3] 64-bit futexes: x86 support
References: <200805310127.m4V1RLdP013819@devserv.devel.redhat.com> <alpine.LFD.1.10.0805301923020.3141@woody.linux-foundation.org> <4840C394.2080807@redhat.com> <alpine.LFD.1.10.0805302056170.3141@woody.linux-foundation.org> <4840D335.6040406@redhat.com> <alpine.LFD.1.10.0805302129240.3141@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805302129240.3141@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus Torvalds wrote:
> You just blindly 
> claim that you're the only one who can know things like this and can do 
> serialization, and that your way is the only approach.

Nonsense.  As you wrote yourself, you're only guessing about your
approaches.  You didn't check what we currently do (which is the extra
data stored protected by locks) and you suggest this scheme.

Then you suggest hand-wavingly other schemes and I explain why they
cannot work as efficiently.  I never doubted that they cannot work at
all.  If performance wouldn't be important I would not have to change
the current implementation which works semantically just fine.


> Sure, futex use and user space is not the same as the kernel code. It's 
> possible that you really do need 64-bit futexes. But quite frankly, the 
> only thing you have proven so far is that you're an ass.

Well, I don't know what you're reading into what I wrote.  I've only
explained what is wrong with each of your proposals and arguments.  If
pointing out the flaws makes me an ass then so be it.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhA2AcACgkQ2ijCOnn/RHTiPQCgzWqXP1EW8HID9FuzbgQa70fL
THsAoLJvUKJO+hqFM3Hd3cHlOCIKhRoF
=ab2b
-----END PGP SIGNATURE-----
