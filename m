Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbYKYTqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbYKYTqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 14:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbYKYTq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 14:46:28 -0500
Received: from smtp4-g19.free.fr ([212.27.42.30]:52238 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbYKYTq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 14:46:28 -0500
Message-ID: <492C55FC.2040506@free.fr>
Date: Tue, 25 Nov 2008 20:46:04 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
       Derek Smithies <derek@indranet.co.nz>, ath5k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, wally@theblackmoor.net,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [ath5k-devel] Unusually low speeds with ath5k and iwl3945
References: <492719ED.5000006@gmail.com> <20081122005240.GA27826@hash.localnet>	<alpine.DEB.2.00.0811221643030.7067@monster> <4927FC0C.10900@gmail.com> <492A5913.3070007@free.fr> <492A7733.2000205@openwrt.org>
In-Reply-To: <492A7733.2000205@openwrt.org>
X-Enigmail-Version: 0.95.7
OpenPGP: url=http://benoit.papillault.free.fr/pgp/benoit.papillault.pgp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Felix Fietkau a écrit :
> While reading the code for calculating the frame duration, i noticed
> something odd: It doesn't seem to be taking into account the short
> vs long preamble distinction for ERP rates. IMHO this might be causing
> issues like this. I've seen similar behaviour a long time ago when testing
> iwl3945 against a Broadcom AP with exactly the same throughput drop (500-
> 600 kbits/s).
> When I analyzed the problem with an extra monitor mode card, I found out
> that the throughput drop is caused by a huge number of retransmissions,

In the test I've done, there was no retransmission at all (no
duplicates). I don't save a capture file, so I cannot tell for sure.

What is the code computing frame duration you are referring to? How it
could affect the hardware behavior?

> and if I remember correctly (I didn't look for this specifically back then),
> the retransmissions went down the rate scaling table until they hit the
> first non-ERP rate and that one worked on the first try.
> 
> Johannes, does that sound like a probable cause? If so, it should be easy
> to fix.
> 
> - Felix
> 

Regards,
Benoit
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJLFX8OR6EySwP7oIRAp2pAJ0batdz64sh9L82CIKzkmVcLyANygCeOq5q
D18DQ/Ko9ggdGn5lmshlMJs=
=3efH
-----END PGP SIGNATURE-----
