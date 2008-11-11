Return-Path: <linux-kernel-owner+w=401wt.eu-S1752277AbYKKTqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbYKKTqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 14:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYKKTqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 14:46:15 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:45260 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbYKKTqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 14:46:14 -0500
Message-ID: <4919E1E8.2010505@novell.com>
Date: Tue, 11 Nov 2008 14:50:00 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: mingo@elte.hu, rostedt@goodmis.org, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Series short description
References: <20081111142323.28477.41235.stgit@dev.haskins.net> <4919DD9B.1070104@nortel.com>
In-Reply-To: <4919DD9B.1070104@nortel.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD05C49A89420C291E66D8D40"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD05C49A89420C291E66D8D40
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Chris Friesen wrote:
> Gregory Haskins wrote:
>> Hi Ingo, Steven, Peter,
>>   This series applies roughly to mainline as an enhancement to the
>> sched_rt
>>   logic.  Peter and I were discussing some of the unecessary overhead =
in
>>   pull_rt_tasks() via IRC, and this is my RFC attempt to address the
>> problem.
>>
>>   I have built/booted this on a 4-way C2D Xeon box and it passes
>> preempt-test.
>
> At first blush it looks reasonable, but do you have any performance
> numbers?

Hi Chris,
  That is a perfectly reasonable request, but unfortunately I do not
have any at this time.  Its currently all based on the observation that
pull_rt_tasks() can cause excessive rq->lock contention and the theory
that this should reduce the cases where that happens.  It still needs to
be proven and quantified, outside of the basic litmus test I gave it
before posting.

I will try to get to this ASAP.

Regards,
-Greg



--------------enigD05C49A89420C291E66D8D40
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkkZ4egACgkQlOSOBdgZUxnEEgCfbc6CY1234HeFa+5Srx6/WQb3
GuYAmwW+km5A4ktQMG33EmZ2UuVtvP/F
=XjUL
-----END PGP SIGNATURE-----

--------------enigD05C49A89420C291E66D8D40--
