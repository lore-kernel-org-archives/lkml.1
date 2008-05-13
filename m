Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbYEMEnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbYEMEnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 00:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbYEMEnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 00:43:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbYEMEnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 00:43:14 -0400
Message-ID: <48291C37.2030403@redhat.com>
Date: Mon, 12 May 2008 21:42:31 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 02/18] flag parameters: paccept
References: <200805062118.m46LI7SS004041@devserv.devel.redhat.com> <20080512211056.16e07167.akpm@linux-foundation.org>
In-Reply-To: <20080512211056.16e07167.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
> because afacit arm doesn't implement set_restore_sigmask() and nor does
> it need to, because it doesn't set HAVE_SET_RESTORE_SIGMASK.

pselect isn't define if HAVE_SET_RESTORE_SIGMASK isn't defined.  That's
fine since pselect offers nothing over select except the signal
handling.  For paccept we'll have to be a bit more sophisticated, I'm
afraid.  Patch in a few minutes.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIKRw32ijCOnn/RHQRArz0AJ9RXoICEi/1Wmc2g/Xg7QMpaRfMjACggwhC
ON/2WP6i03QBerzu6qe/iPs=
=S2H+
-----END PGP SIGNATURE-----
