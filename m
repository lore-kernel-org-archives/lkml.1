Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbZCJT5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbZCJT5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 15:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZCJT46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 15:56:58 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:32973 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbZCJT45 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 15:56:57 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip V2] x86: cpu architecture debug code
In-Reply-To: Your message of "Tue, 10 Mar 2009 16:20:29 BST."
             <20090310152029.GN3850@elte.hu>
From: Valdis.Kletnieks@vt.edu
References: <1236684201.3301.11.camel@localhost.localdomain> <20090310122806.GE5794@elte.hu> <1236697752.3387.2.camel@localhost.localdomain>
            <20090310152029.GN3850@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1236714808_3963P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 10 Mar 2009 15:53:28 -0400
Message-ID: <36674.1236714808@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1236714808_3963P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <36658.1236714794.1@turing-police.cc.vt.edu>

On Tue, 10 Mar 2009 16:20:29 BST, Ingo Molnar said:

> If you look at arch/x86/mm/fault.c, they are sorted by length, 
> and within the same length they are sorted alphabetically.

Huh? I just did a 'git pull' of Linus's tree, and I see fault.c looking like:

#include <linux/signal.h>
#include <linux/sched.h>
#include <linux/kernel.h>
#include <linux/errno.h>
#include <linux/string.h>
#include <linux/types.h>
#include <linux/ptrace.h>
#include <linux/mmiotrace.h>
#include <linux/mman.h>
#include <linux/mm.h>
#include <linux/smp.h>
#include <linux/interrupt.h>

Not sure how it's sorted, but it's appparently not by length first.  Also,
wouldn't logical interdependency count for something here, including stuff
in the order needed?


--==_Exmh_1236714808_3963P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJtsU4cC3lWbTT17ARAjLDAKC7ETQUtaNqkR5Z11DT71W+NqoIPQCgtI+w
MqE8L5qP7eeJwBcqqQBjRQM=
=SV1g
-----END PGP SIGNATURE-----

--==_Exmh_1236714808_3963P--
