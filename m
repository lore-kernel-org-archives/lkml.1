Return-Path: <linux-kernel-owner+w=401wt.eu-S1765639AbYEVFSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765639AbYEVFSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 01:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbYEVFSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 01:18:38 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:43246 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbYEVFSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 01:18:37 -0400
Message-ID: <4835022B.2090400@kernel.org>
Date: Wed, 21 May 2008 22:18:35 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] security: protect legacy apps from insufficient	privilege
References: <483444C1.6050308@kernel.org> <20080521203405.GA27901@sergelap.wowway.com>
In-Reply-To: <20080521203405.GA27901@sergelap.wowway.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Serge E. Hallyn wrote:
| Quoting Andrew G. Morgan (morgan@kernel.org):
| This is a fail-safe additional feature for filesystem capability support.
|
| Cheers
|
| Andrew

~From 916b252d3b631214acea6df6c61e94ce6770fdf7 Mon Sep 17 00:00:00 2001
From: Andrew G. Morgan <morgan@kernel.org>
Date: Thu, 15 May 2008 23:17:13 -0700
Subject: [PATCH] Protect legacy applications from executing with
insufficient privilege.
[..]

| Assuming (as it appears) the only change from last time is that you
| dropped the part changing cap_bprm_apply_creds() contraints for a
| ptraced process, then

Yes. That's the only material change. I also added a comment explaining
the "strange" (since it caused some concern last time around) cap_bset |
cap_inheritable bit...

| Acked-by: Serge Hallyn <serue@us.ibm.com>

| I'll try to give it a good test-run next week.

Thanks

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFINQIr+bHCR3gb8jsRAjUtAJ0dX67kT3AAtR7gUZgCPiXS2t+nzQCgghmv
GSgqeiwwbZXcc6tSh9957Fo=
=dmv/
-----END PGP SIGNATURE-----
