Return-Path: <linux-kernel-owner+w=401wt.eu-S1759478AbYEAMhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbYEAMhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbYEAMh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:37:27 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:59424 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbYEAMh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:37:26 -0400
Date: Thu, 1 May 2008 13:37:38 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: =?ISO-8859-2?Q?Pawe=B3?= <anilatx@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at mm/rmap.c:669 (during localegen)
In-Reply-To: <48199F05.507@gmail.com>
Message-ID: <Pine.LNX.4.64.0805011325290.22839@blonde.site>
References: <48199F05.507@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1025004510-1209645458=:22839"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1025004510-1209645458=:22839
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 1 May 2008, Pawe=C5=82 wrote:
>=20
> Every time I try to generate locales computer reboots or hangs. To ensure
> that's not matter of graphDrivers I checked also in runlevel 1 and
> "init=3D/bin/bash".
>=20
> Linux debby 2.6.25 #1 PREEMPT Mon Apr 28 15:18:31 CEST 2008 x86_64 GNU/Li=
nux
> gcc (GCC) 4.2.3 (Debian 4.2.3-3)
>=20
> [kern.log:]
> //May  1 11:20:09 debby kernel: NVRM: bad caching on address
> 0xffff81003a910000: actual 0x173 !=3D expected 0x17b
>=20
> May  1 11:25:44 debby kernel: Eeek! page_mapcount(page) went negative! (-=
1)
> May  1 11:25:44 debby kernel:   page pfn =3D 257d2
> May  1 11:25:44 debby kernel:   page->flags =3D 2200000000001c
> May  1 11:25:44 debby kernel:   page->count =3D 0
> May  1 11:25:44 debby kernel:   page->mapping =3D 0000000000000000
> May  1 11:25:44 debby kernel:   vma->vm_ops =3D 0x0
> May  1 11:25:44 debby kernel: ------------[ cut here ]------------
> May  1 11:25:44 debby kernel: kernel BUG at mm/rmap.c:669!
> May  1 11:25:44 debby kernel: invalid opcode: 0000 [1] PREEMPT
> May  1 11:25:44 debby kernel: CPU 0
> May  1 11:25:44 debby kernel: Modules linked in: nvidia(P) ...
> May  1 11:25:44 debby kernel: Pid: 3007, comm: localedef Tainted: P
> 2.6.25 #1
> May  1 11:25:44 debby kernel: RIP: 0010:[<ffffffff80270c74>]
> [<ffffffff80270c74>] page_remove_rmap+0x164/0x180

Sorry, you'll have to ask Nvidia to help you with this: we don't
know what their driver is up to, and don't have any "NVRM" errors in
2.6.25 source; they should be grateful for your reproducible test case.

Hugh
--8323584-1025004510-1209645458=:22839--
