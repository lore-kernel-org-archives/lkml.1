Return-Path: <linux-kernel-owner+w=401wt.eu-S934403AbZAPNnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934403AbZAPNnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761024AbZAPNm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:42:57 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:41477 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760598AbZAPNm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:42:56 -0500
Message-ID: <49708F94.4000509@novell.com>
Date: Fri, 16 Jan 2009 08:45:56 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: rostedt@home.goodmis.org, peterz@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] fixes for tip/sched/rt
References: <496DE6E4.1010209@novell.com> <20090114144317.11627.69111.stgit@dev.haskins.net> <20090115123051.GA21096@elte.hu> <20090116133530.GA23674@elte.hu>
In-Reply-To: <20090116133530.GA23674@elte.hu>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF402435FCEDE9FDC1F4EE7FA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF402435FCEDE9FDC1F4EE7FA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> here's a new build failure with tip/sched/rt:
>
>   LD      .tmp_vmlinux1
> kernel/built-in.o: In function `set_curr_task_rt':
> sched.c:(.text+0x3675): undefined reference to `plist_del'
> kernel/built-in.o: In function `pick_next_task_rt':
> sched.c:(.text+0x37ce): undefined reference to `plist_del'
> kernel/built-in.o: In function `enqueue_pushable_task':
> sched.c:(.text+0x381c): undefined reference to `plist_del'
>
> 	Ingo
>  =20
Im on it.

-greg


--------------enigF402435FCEDE9FDC1F4EE7FA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAklwj5QACgkQlOSOBdgZUxmNjQCfQLHBDa1T8hFNetE26VWIB+T0
lwoAn29onqYxDbOzUnwhimJEHS4YYzbN
=9R5m
-----END PGP SIGNATURE-----

--------------enigF402435FCEDE9FDC1F4EE7FA--
