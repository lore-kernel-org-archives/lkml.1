Return-Path: <linux-kernel-owner+w=401wt.eu-S1760172AbXKAOx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbXKAOx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbXKAOxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:53:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312AbXKAOxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:53:51 -0400
Message-ID: <4729E86A.9090705@redhat.com>
Date: Thu, 01 Nov 2007 07:53:30 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch] PID namespace design bug, workaround
References: <20071101144307.GA29566@elte.hu>
In-Reply-To: <20071101144307.GA29566@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ingo Molnar wrote:
> +	clone_flags &= ~CLONE_NEWPID;

I think the call should rather fail than silently drop the bit but aside
from that I agree.  The problems we'd run into if the feature is getting
used as-is are severe.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHKehh2ijCOnn/RHQRAqHAAJkBu7Uj8T5J2ZlLty096zXH7IVcwACfRhlt
EpwnZ1UodJXJiPpxGN8FEYo=
=S/kB
-----END PGP SIGNATURE-----
