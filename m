Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbZGaVi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbZGaVi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbZGaViz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:38:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38969 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbZGaVix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:38:53 -0400
Message-ID: <4A73641C.7070404@redhat.com>
Date: Fri, 31 Jul 2009 14:37:32 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] information leak in sigaltstack
References: <200907311948.n6VJm5Gf010118@hs20-bc2-1.build.redhat.com> <alpine.LFD.2.01.0907311407040.24841@localhost.localdomain> <alpine.LFD.2.01.0907311428370.3304@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0907311428370.3304@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus Torvalds wrote:

> 	if (alignof(oss.ss_flags) != alignof(oss))
> 		memset(&oss, 0, sizeof(oss));
> 
> instead? That would seem to be less subtle, and more to-the-point.

I was just composing a reply with basically this.  So  you'll apply this
and don't wait for me to send a new version of the patch, right?

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpzZBwACgkQ2ijCOnn/RHSMUACeJkKaHTG97OcSkCa3jFCIFxvL
9JsAoK7IuTCiW+i1oR9Xlt3wo0YZPTCw
=9A0Y
-----END PGP SIGNATURE-----
