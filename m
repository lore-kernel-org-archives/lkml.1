Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbYDBJRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbYDBJRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 05:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbYDBJR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 05:17:26 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:44322 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbYDBJRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 05:17:25 -0400
Subject: Re: [PATCH] evdev: Release eventual input device grabs when
	getting disconnected
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>
In-Reply-To: <20080401152011.GA3044@atjola.homenet> (sfid-20080401_162047_241445_82BD3FEB)
References: <20080330184259.GB21375@atjola.homenet>
	 <20080331190509.GA2876@atjola.homenet>
	 <1207050678.5143.43.camel@johannes.berg>
	 <20080401152011.GA3044@atjola.homenet>
	 (sfid-20080401_162047_241445_82BD3FEB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-49gKxvZvjyBH2O1Ds075"
Date: Wed, 02 Apr 2008 11:17:15 +0200
Message-Id: <1207127835.10910.11.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-49gKxvZvjyBH2O1Ds075
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I tried with slab+debugging, slub+debugging (SLUB_DEBUG_ON was set),
> various preemption models, UP and SMP. No luck. I also wrote a test
> program like yours to eliminate any effects caused by different X.org
> versions, but it just doesn't want to crash :-/

Strange. I don't know then, I used 'appletouch' to reproduce, maybe
there's as bug in appletouch's exit function?

johannes

--=-49gKxvZvjyBH2O1Ds075
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/NPGqVg1VMiehFYAQJcBg//cU6B9QGIRHLwPaPF8Ps4niyVv0DkSbjl
mlmxLXekW3nWiN7z+lzGU7s9afe7OXURXfKtP2aoaDn4mPo5bow3DYMnezETYEZf
SW1K1+gomYNqE+BpTCQHAHRPYxonyY/sTCrfUuq1SxfOs+QA0v7MpuhYmbU4ZjDR
GACuAvQvIamCVccSOoqKuCZtIPRqBZHxfZ/ZLDvQps8Jfa70tAZPYVokEQOL4CbF
7qYGj4D5p+ui8thEFJZhZ2w2Pc2k9GtZUk+YT2+NVDGS5UNmdI8BIHDbIrsavmnY
3V8rIAIDtk3cNY/c8mVNTqFfYKazpkTdCIxQqbPR9BQcmhBvucUrAZHLqZW3FTXm
pinylkBgisRN2lRZDHKH3TWe31hUy7sDTNlmiJScKScoJdKeym2GUh5/FBOilNUy
MMrn8J7tJVy9yOHzVLtwimFFz5aHc2u3B05yE8kgvNxBAt5hsZx3o5GECCcCP0xC
ry1A8uWSNv+GcLfeu9PRL0A6OCpYbcPd+kKry2yXcQAJbnRf9ApCa6qCoLPFUhui
j+S+k+qQ5cefL3NtAr8vQcE2JBqoheBAzqMwR6oqWpjf13ZyJ2gNHxJzMMVZxcig
M6zcBgRJzc6azPcfSOA7jojxzSLsjdXAEo+7X/dtvM43E7MgqF85gyFjk69hrCIQ
UILKEoYiTNQ=
=T2yz
-----END PGP SIGNATURE-----

--=-49gKxvZvjyBH2O1Ds075--

