Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbYH0MQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbYH0MQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 08:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbYH0MP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 08:15:57 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:53589 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406AbYH0MP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 08:15:56 -0400
Message-ID: <48B544EB.4040201@novell.com>
Date: Wed, 27 Aug 2008 08:13:31 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu, srostedt@redhat.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       gregory.haskins@gmail.com
Subject: Re: [PATCH v2 3/6] sched: make double-lock-balance fair
References: <20080826173131.16413.17862.stgit@dev.haskins.net> <20080826173500.16413.40514.stgit@dev.haskins.net> <1219825295.6462.54.camel@twins> <20080827102646.GA5818@wotan.suse.de> <1219833668.6462.72.camel@twins> <20080827105615.GB5818@wotan.suse.de>
In-Reply-To: <20080827105615.GB5818@wotan.suse.de>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA481E99CD8D86C3BD7225082"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA481E99CD8D86C3BD7225082
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable

Nick Piggin wrote:
> On Wed, Aug 27, 2008 at 12:41:08PM +0200, Peter Zijlstra wrote:
>  =20
>  =20
>> Does it make sense to make this _double_lock_balance() thing depend on=

>> that too?
>>    =20
>
> Hmm, you might have a good point there. Greg?
>  =20

This makes sense to me.



--------------enigA481E99CD8D86C3BD7225082
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAki1ROsACgkQlOSOBdgZUxnHCgCffGZMpCCyQTlHu72PCbo+98Cw
ba4AoITHFrXAnP3vqh713kvtTX7LsMXo
=V7HR
-----END PGP SIGNATURE-----

--------------enigA481E99CD8D86C3BD7225082--
