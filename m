Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbXICIR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbXICIR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 04:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbXICIRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 04:17:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbXICIRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 04:17:21 -0400
To: James Pearson <james-p@moving-picture.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Guy Streeter <guy.streeter@gmail.com>,
       James Pearson <james-p@moving-picture.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 4096 byte limit to /proc/PID/environ ?
References: <4474B7DB.8000304@moving-picture.com>
	<200605242029.k4OKTn9C031700@terminus.zytor.com>
	<447EF58C.6000605@moving-picture.com>
	<52dd17640708150954q798d137cn1b07739785917c5b@mail.gmail.com>
	<46C33700.1060605@zytor.com> <46D6CBED.4040301@moving-picture.com>
From: Anton Arapov <aarapov@redhat.com>
X-URL: http://people.redhat.com/aarapov
Date: Mon, 03 Sep 2007 10:17:11 +0200
In-Reply-To: <46D6CBED.4040301@moving-picture.com> (James Pearson's message of "Thu\, 30 Aug 2007 14\:53\:49 +0100")
Message-ID: <h8fy1w40zc.fsf@pepelac.englab.brq.redhat.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

James Pearson <james-p@moving-picture.com> writes:
> H. Peter Anvin wrote:
>> Guy Streeter wrote:
>>>On 6/1/06, James Pearson <james-p@moving-picture.com> wrote:
>>>>H. Peter Anvin wrote:
[...skipped...]
>>>>The following patch is based on the /proc/PID/mem code appears to work =
fine.
>>>This thread has gone stale. The PAGE_SIZE limit still exists. Is this
>>>solution acceptable?
>> Can we avoid the code duplication?
> There isn't that much that is duplicated - and there are also bits of
> the /proc/PID/mem code that are not needed in this case, so I'm not
> really sure if it is worth doing.
>
> I did submit a patch a few months ago - see:
> <http://marc.info/?l=3Dlinux-kernel&m=3D117862109623007&w=3D2>
  Yep, I'm sure we should not reuse something from mem part, there are some=
 insignificant code duplicating. If we will try to avoid this, it will comp=
licate code and does not bring any advantage.=20

=2D-=20
Anton Arapov, <aarapov@redhat.com>

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFG28MMVub9yW+oyBIRAsDhAJ4lSE2zpJYVV4KwWiE4YkQvsNE7AgCeNaPt
Glp9WH7+7ZCzqRh2ri8mHKo=
=AO7U
-----END PGP SIGNATURE-----
--=-=-=--
