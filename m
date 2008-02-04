Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbYBDBLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbYBDBLZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 20:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbYBDBLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 20:11:17 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:54482 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbYBDBLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 20:11:16 -0500
Message-ID: <47A6661D.7020305@kernel.org>
Date: Sun, 03 Feb 2008 17:10:53 -0800
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: =?UTF-8?B?SXNtYWlsIETDtm5tZXo=?= <ismail@pardus.org.tr>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH] per-process securebits
References: <47A2D439.9050704@kernel.org> <200802030825.49221.ismail@pardus.org.tr> <47A66119.90702@kernel.org> <200802040254.50444.ismail@pardus.org.tr>
In-Reply-To: <200802040254.50444.ismail@pardus.org.tr>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ismail Dönmez wrote:
| What I meant to ask was what does "per-process securebits" brings as
extra.

It allows you to create a legacy free process tree. For example, a
chroot, or container (which Serge can obviously explain in more detail),
environment in which root has no privilege at all. One in which
privilege comes only from filesystem capabilities.

| FWIW in Pardus 2008 we'll enable Posix file capabilities by default so
people
| could "harden" their setups.

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFHpmYd+bHCR3gb8jsRAlDHAJ9RvFRieU2eUPJUHh7K84NMLmytTQCgupfS
KxdoXz400AeMWJiaikGH9U8=
=yx8I
-----END PGP SIGNATURE-----
