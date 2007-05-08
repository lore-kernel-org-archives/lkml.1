Return-Path: <linux-kernel-owner+w=401wt.eu-S1032164AbXEHVId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032164AbXEHVId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967944AbXEHVIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:08:31 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:60575 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967681AbXEHVIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:08:30 -0400
From: "=?iso-8859-9?q?S=2E=C7a=F0lar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH 1/8] Restructuring hpet timer generic clock interfaces
Date: Wed, 9 May 2007 00:07:52 +0300
User-Agent: KMail/1.9.6
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andi Kleen" <ak@suse.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Chris Wright" <chrisw@sous-sol.org>
References: <653FFBB4508B9042B5D43DC9E18836F55DF0A8@scsmsx415.amr.corp.intel.com>
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F55DF0A8@scsmsx415.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3630267.rdPmg34D5N";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705090008.00916.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3630267.rdPmg34D5N
Content-Type: text/plain;
  charset="iso-8859-9"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

08 May 2007 Sal tarihinde, Pallipadi, Venkatesh =FEunlar=FD yazm=FD=FEt=FD:=
=20
> Hmm. Looks like timer was somehow not set correctly.
> Can you try only the first 5 patches in the patchset and leave out the la=
st
> three and check whether it works.

Yep, first 5 patches works fine,

[caglar@zangetsu][~]> dmesg | grep hpet
hpet clocksource registered
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
hpet clockevent registered
Time: hpet clocksource has been installed.

[caglar@zangetsu][~]> cat /proc/timer_list
=2E..
Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     9223372036854775807 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000001
tick_broadcast_oneshot_mask: 00000000
=2E..

If you need more output/log etc. please just say :)

Cheers
=2D-=20
S.=C7a=F0lar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart3630267.rdPmg34D5N
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGQOawy7E6i0LKo6YRAiVYAJ4kDb+wP7q9HvNsov05dl3UpbHzxQCg1JOb
ia/Ub9F1nuK0T54BJN7lbKA=
=MnFB
-----END PGP SIGNATURE-----

--nextPart3630267.rdPmg34D5N--
