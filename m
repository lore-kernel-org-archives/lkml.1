Return-Path: <linux-kernel-owner+w=401wt.eu-S1763642AbXFROOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763642AbXFROOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 10:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760884AbXFROOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 10:14:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbXFROOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 10:14:35 -0400
Message-ID: <467692DA.8050601@redhat.com>
Date: Mon, 18 Jun 2007 07:12:42 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Pierre Peiffer <pierre.peiffer@bull.net>
CC: Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] Futex: Revert the non-functional REQUEUE_PI
References: <1182107470.8176.455.camel@chaos> <46766552.3080803@bull.net>
In-Reply-To: <46766552.3080803@bull.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Pierre Peiffer wrote:
> Once again, it's a pity that people didn't spent time to comment on this
> when I was working on this.

It was no accusation.  IMO this is how it should work.  The problems
became visible only once the code was being used.  This is what the
current model allows: we find problems and since the development cycle
requires changes to be added at the beginning we have time to back
changes out again.  No harm done.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGdpLa2ijCOnn/RHQRArfeAJ941sp77rF4BN6heEZvB/E6Tx29KwCeI34f
um8soonlsK4Lp1k+t0WHzhM=
=9v8e
-----END PGP SIGNATURE-----
