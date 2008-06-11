Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbYFKAiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbYFKAiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 20:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbYFKAiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 20:38:02 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:42840 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbYFKAiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 20:38:00 -0400
Message-ID: <484F1E63.8070408@kernel.org>
Date: Tue, 10 Jun 2008 17:37:55 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bugfix: was Re: [ linus-git ] prctl(PR_SET_KEEPCAPS,
 ...) is broken for some configs, e.g. CONFIG_SECURITY_SELINUX
References: <1212932321.4675.9.camel@earth> <484BF662.9070100@kernel.org> <20080608110630.08a45cc6.akpm@linux-foundation.org> <484C5E84.2020307@kernel.org> <20080608163926.56f1be3d.akpm@linux-foundation.org> <20080609171741.GA13403@us.ibm.com> <484E0280.2050305@kernel.org> <20080610191451.GL4018@sequoia.sous-sol.org>
In-Reply-To: <20080610191451.GL4018@sequoia.sous-sol.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Chris Wright wrote:
|> +	switch (option) {
|> +	case PR_CAPBSET_READ:
|> +		*rc_p = (cap_valid(arg2) ? 1 : -EINVAL);
|> +		break;
|
| Do we need this one?  It's new to 2.6.25, so I think we could not
| worry about emulating it here.

We're talking about 'fixing' 2.6.26 no? I'd rather not open up the
possibility that I have to 'fix' it again because of dropping a feature
of 2.6.25... (Forgive me if I sound like I'm climbing out of a septic
tank here.)

Dmitry: please verify this change addresses your problem...

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFITx5i+bHCR3gb8jsRAi8dAJ9A8v+wbSiqikGaW8vIY2HcS0Hs5QCfU2gT
1z9FHzHTgSeBMqHak6+VCtU=
=jKT2
-----END PGP SIGNATURE-----
