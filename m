Return-Path: <linux-kernel-owner+w=401wt.eu-S1762028AbYDXPqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762028AbYDXPqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764575AbYDXPqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:46:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762708AbYDXPqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:46:30 -0400
Message-ID: <4810AB29.5030604@redhat.com>
Date: Thu, 24 Apr 2008 08:45:45 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] alternative to sys_indirect, part 1
References: <200804240403.m3O43us8028699@devserv.devel.redhat.com>	<20080424112514.055d8071@the-village.bc.nu>	<481096C3.2020206@redhat.com>	<20080424152436.6cf53c1b@the-village.bc.nu>	<4810A46B.1090809@redhat.com> <20080424160352.30f2dd5b@the-village.bc.nu>
In-Reply-To: <20080424160352.30f2dd5b@the-village.bc.nu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Alan Cox wrote:
> Kernel socket type values are assigned by the kernel team so that
> isn't a problem.

Again, it's not about assigned values.  It about those not yet assigned.

> POSIX has no interface for this new behaviour you propose so that is
> complete crap. The moment you use one of these features you stepped
> outside of the POSIX spec - and you know that. If there was an existing
> standard we wouldn't have a problem.

Oh really?  You open a server socket, use fcntl(FD_CLOEXEC), and then
accept().  This is identical to the new behavior and it is very well
defined in POSIX.  Hence, code which uses fcntl() this way today will
see a change with your proposal.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIEKsp2ijCOnn/RHQRAl7yAJ40IosF+DLjiFtmuOt/t9LShBt46ACfbVi6
BXwZE0fKUAh0Iqmrme3On6A=
=iDY5
-----END PGP SIGNATURE-----
