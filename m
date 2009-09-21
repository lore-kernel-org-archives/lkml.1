Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbZIUX7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbZIUX7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 19:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbZIUX7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 19:59:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647AbZIUX7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 19:59:46 -0400
Message-ID: <4AB8133D.7060506@redhat.com>
Date: Mon, 21 Sep 2009 16:58:53 -0700
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: "Luck, Tony" <tony.luck@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Yu, Fenghua" <fenghua.yu@intel.com>, ebmunson@us.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-man@vger.kernel.org, mtk.manpages@gmail.com,
       Randy Dunlap <randy.dunlap@oracle.com>, rth@twiddle.net,
       ink@jurassic.park.msu.ru, linux-ia64@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] remove duplicate asm/mman.h files
References: <cover.1251197514.git.ebmunson@us.ibm.com> <200909181848.42192.arnd@arndb.de> <alpine.DEB.1.00.0909181236190.27556@chino.kir.corp.google.com> <200909211031.25369.arnd@arndb.de> <alpine.DEB.1.00.0909210208180.16086@chino.kir.corp.google.com> <Pine.LNX.4.64.0909211258570.7831@sister.anvils> <alpine.DEB.1.00.0909211553000.30561@chino.kir.corp.google.com> <57C9024A16AD2D4C97DC78E552063EA3E29CC3F1@orsmsx505.amr.corp.intel.com> <alpine.DEB.1.00.0909211638001.2388@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0909211638001.2388@chino.kir.corp.google.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

David Rientjes wrote:
> Ulrich wanted to do this last year but it appears to have been dropped.

I've mentioned that at that time, these flags cannot be used at all for
stacks.  And I don't know for what else it is useful.  They should
really be removed.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iEYEARECAAYFAkq4Ez0ACgkQ2ijCOnn/RHQNtACfX+y5pIQhDusikKiQwQ8nvGRN
cI8An0oThAXSwXRALt9598vbPbiVwEeJ
=sxfU
-----END PGP SIGNATURE-----
