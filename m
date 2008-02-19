Return-Path: <linux-kernel-owner+w=401wt.eu-S1762684AbYBSXmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762684AbYBSXmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbYBSXl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:41:59 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40661 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbYBSXl6 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:41:58 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       roland@redhat.com, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [PATCH] do_signal_stop: use signal_group_exit()
In-Reply-To: Your message of "Sun, 17 Feb 2008 21:11:14 MST."
             <m1skzq9a59.fsf@ebiederm.dsl.xmission.com>
From: Valdis.Kletnieks@vt.edu
References: <20080215180204.GA4359@tv-sign.ru> <20080215193756.9e5b8205.akpm@linux-foundation.org> <20080216140212.GA1421@tv-sign.ru> <20080217231019.GA83@tv-sign.ru>
            <m1skzq9a59.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1203464394_762P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 19 Feb 2008 18:39:54 -0500
Message-ID: <23492.1203464394@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1203464394_762P
Content-Type: text/plain; charset=us-ascii

On Sun, 17 Feb 2008 21:11:14 MST, Eric W. Biederman said:
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> > On 02/16, Oleg Nesterov wrote:
> >> On 02/15, Andrew Morton wrote:
> >> > : BUG: unable to handle kernel paging request at 0000000000200200

> >> > : Call Trace:
> >> > :  [<ffffffff80237727>] ? release_task+0x152/0x2e5
> >> > :  [<ffffffff80237f81>] ? do_wait+0x6c7/0xa1c
> >> > :  [<ffffffff8022f4cc>] ? default_wake_function+0x0/0xe
> >> > :  [<ffffffff8023e670>] ? sys_rt_sigaction+0x7a/0x98
> >> > :  [<ffffffff80238360>] ? sys_wait4+0x8a/0xa1
> >> > :  [<ffffffff8020be4b>] ? system_call_after_swapgs+0x7b/0x80

> Thanks.  Looks like we need to grab a lock there.
> At a quick skim I think we need the tty lock.

*ping* - Any further activity on this one?  I got bit by it as well on
the very first attempted boot of 25-rc2-mm1, the instant it tried to leave
single-user and go multi-user.

--==_Exmh_1203464394_762P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHu2jKcC3lWbTT17ARApklAKC3EY2eJnCmgfF4+GK6No3zbv2yzgCgqtIe
iZdAk4/kv6xk9ZGX+MAalcA=
=OSi4
-----END PGP SIGNATURE-----

--==_Exmh_1203464394_762P--
