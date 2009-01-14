Return-Path: <linux-kernel-owner+w=401wt.eu-S1762895AbZANP0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762895AbZANP0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756517AbZANP0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:26:02 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:34906 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbZANP0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:26:01 -0500
Message-ID: <496E04BB.5010206@novell.com>
Date: Wed, 14 Jan 2009 10:28:59 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: mingo@elte.hu, rostedt@home.goodmis.org, peterz@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] sched: de CPP-ify the scheduler code
References: <20090114144317.11627.69111.stgit@dev.haskins.net> <20090114144624.11627.12938.stgit@dev.haskins.net> <alpine.DEB.1.10.0901141009410.6759@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0901141009410.6759@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6BDC389FB73B2564D1831CE7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6BDC389FB73B2564D1831CE7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Steven Rostedt wrote:
>
> On Wed, 14 Jan 2009, Gregory Haskins wrote:
>
>  =20
>> =20
>> -#define enqueue_pushable_task(rq, p) do { } while (0)
>> -#define dequeue_pushable_task(rq, p) do { } while (0)
>> +static inline
>> +void enqueue_pushable_task(struct rq *rq, struct task_struct *p) {}
>> +static inline
>> +void dequeue_pushable_task(struct rq *rq, struct task_struct *p) {}
>>    =20
>
> Wouldn't the above look better as:
>
> static inline void
> enqueue_pushable_task(struct rq *rq, struct task_struct *p)
> {
> }
> static inline void
> dequeue_pushable_task(struct rq *rq, struct task_struct *p)
> {
> }
>
>  =20
I personally like to try to keep disabled functions ideally as close to
one line as possible to visually denote that it isn't doing anything
worth looking at.  But I don't feel strongly either way, so whatever
makes you guys happy. :)

Shall I convert the others to this form as well?

-Greg




--------------enig6BDC389FB73B2564D1831CE7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkluBLsACgkQlOSOBdgZUxm44wCeI963PZah2HS81eLtLrznB4VN
V/sAnA2sNmP3yRsbIUP62iCJKCefczmK
=wE8+
-----END PGP SIGNATURE-----

--------------enig6BDC389FB73B2564D1831CE7--
