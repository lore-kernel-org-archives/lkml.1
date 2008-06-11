Return-Path: <linux-kernel-owner+w=401wt.eu-S1758542AbYFKAjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542AbYFKAjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 20:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbYFKAji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 20:39:38 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:53526 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbYFKAji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 20:39:38 -0400
Message-ID: <484F1EC4.5050906@kernel.org>
Date: Tue, 10 Jun 2008 17:39:32 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bugfix: was Re: [ linus-git ] prctl(PR_SET_KEEPCAPS,
 ...) is broken for some configs, e.g. CONFIG_SECURITY_SELINUX
References: <1212932321.4675.9.camel@earth> <484BF662.9070100@kernel.org> <20080608110630.08a45cc6.akpm@linux-foundation.org> <484C5E84.2020307@kernel.org> <20080608163926.56f1be3d.akpm@linux-foundation.org> <20080609171741.GA13403@us.ibm.com> <484E0280.2050305@kernel.org> <20080610191241.GA17311@us.ibm.com>
In-Reply-To: <20080610191241.GA17311@us.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Serge E. Hallyn wrote:
+		else
+			current->securebits &=
+				~issecure_mask(SECURE_KEEP_CAPS);

| In these last two conditions, don't you need to set *rc_p?

| Oh, or my kernel tree may be out of date, as I seem to recall a recent
| patch initializing error to 0 in sys_prctl(), so this wouldn't
| technically be a problem?  Still would seem correct...

Yes, update your kernel and you will find this defaults to zero. I
thought about redundantly forcing it, but decided that it wasn't worth
the pain of working around the 80-column challenged extra indenting. :-(

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFITx7E+bHCR3gb8jsRAulwAJ0U6TwsWMZRs6epQNNWs+f27UuUfgCdEGut
4x/mUDuIX6TvCVnip5sZWVk=
=1PdZ
-----END PGP SIGNATURE-----
