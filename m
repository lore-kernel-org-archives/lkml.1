Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbXKBAWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbXKBAWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 20:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbXKBAWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 20:22:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522AbXKBAWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 20:22:06 -0400
Message-ID: <472A6D91.1020300@redhat.com>
Date: Thu, 01 Nov 2007 17:21:37 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] PID namespace design bug, workaround
References: <20071101144307.GA29566@elte.hu> <4729E7E4.8070208@openvz.org> <4729E936.4040400@redhat.com> <4729EB3C.9050102@openvz.org>
In-Reply-To: <4729EB3C.9050102@openvz.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Pavel Emelyanov wrote:
> The "fix" I mention is just returning -EINVAL in case user orders 
> CLONE_NEWPIDS

That is the "fix" you were referring to?  I was hoping you have a sketch
for a real solution.  If nobody can think of a way to fix this PID
namespaces are IMO not something which should go in at all.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHKm2R2ijCOnn/RHQRAgjXAKCkU9lcWC9aTR0nG89x47AZO9pVfwCgiaVC
/Giyp+en+VbtfFyD8D6v4Xk=
=RnIw
-----END PGP SIGNATURE-----
