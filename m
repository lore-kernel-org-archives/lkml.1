Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbZLUQtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbZLUQtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:49:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756070AbZLUQtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:49:06 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:40899 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873AbZLUQtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:49:05 -0500
Message-ID: <4B2FA6D1.20408@web.de>
Date: Mon, 21 Dec 2009 17:48:17 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Roland McGrath <roland@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, utrace-devel@redhat.com,
       Avi Kivity <avi@redhat.com>
Subject: Re: x86: do_debug && PTRACE_SINGLESTEP broken by	08d68323d1f0c34452e614263b212ca556dae47f
References: <20091218005650.GA20667@redhat.com> <20091218030601.GB16470@nowhere> <20091218172747.GA10924@redhat.com> <20091218200503.2CA0DF9A4@magilla.sf.frob.com> <20091218223230.GA1853@redhat.com> <4B2F4C58.8010303@web.de> <20091221165304.GA5061@redhat.com>
In-Reply-To: <20091221165304.GA5061@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAA83CAA9EFBF8F2AE3C91EEB"
X-Provags-ID: V01U2FsdGVkX1/RhYKDrvwOHzIZ/MFidXlW1GwlhFWk+oh8Zqoj
	JFX9iHC8TeOWXJEek38aKGpnTk/vP/AOndifLS4YW2qZTnR71Q
	TE3u+eDTs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAA83CAA9EFBF8F2AE3C91EEB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Oleg Nesterov wrote:
> On 12/21, Jan Kiszka wrote:
>> Oleg Nesterov wrote:
>>> Hmm. Now I see how wrong I was when I said this code is "obviously wr=
ong" ;)
>=20
> Yes, it is easy to blame the code you don't understand.
>=20
> My apologies to all.
>=20
>>> I'll add the debugging printk's and report the output. Sorry for dela=
y,
>>> can't do this today.
>> Can't reproduce, runs fine here with with 2.6.33-rc1 as both host&gues=
t
>> and qemu-kvm latest git. Host uses kvm-intel.
>=20
> Everything runs fine under 2.6.32 as a _host_ kernel. Previously I did
> the testing under 2.6.26.5-45.fc9.

Makes sense: that kernel (most probably) predates any debug register
virtualization in kvm.

>=20
> Sorry for noise, thanks all for your help.

Never mind.

Jan


--------------enigAA83CAA9EFBF8F2AE3C91EEB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAksvptQACgkQitSsb3rl5xRzBQCaAgAdov69ytRqfLQsawiQUQ70
IMUAoLqv1fpNXczLsWuOoVu3PpJ2D0fH
=wy/b
-----END PGP SIGNATURE-----

--------------enigAA83CAA9EFBF8F2AE3C91EEB--
