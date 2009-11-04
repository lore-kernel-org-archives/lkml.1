Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbZKDQCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbZKDQCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbZKDQCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:02:19 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:61975 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949AbZKDQCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:02:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=dXk2oHdYARrB/58s8Oz8YS3JRCSlvd6tVzkbC6kunJmFFS8t1JdFOZGfySb+ZHfNcd
         6/K2A/sndoSg/o3GFJTEc+ltieeH2r7UVOJ7afGiLXRg0z0dEPuh9d9i0s7mC+oWUlhu
         XJQ16dDgQDtJt/xcYzfYDCxpL/2st/QNcVJ8Y=
Message-ID: <4AF1A587.8000509@gmail.com>
Date: Wed, 04 Nov 2009 11:02:15 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, s.hetze@linux-ag.com,
       Daniel Walker <dwalker@fifo99.com>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCHv8 0/3] vhost: a kernel-level virtio server
References: <20091104155234.GA32673@redhat.com>
In-Reply-To: <20091104155234.GA32673@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9CBB576151305611F6CF6CC2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9CBB576151305611F6CF6CC2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> Ok, I think I've addressed all comments so far here.
> Rusty, I'd like this to go into linux-next, through your tree, and
> hopefully 2.6.33.  What do you think?

I think the benchmark data is a prerequisite for merge consideration, IMO=
=2E

Do you have anything for us to look at?  I think comparison that show
the following are of interest:

throughput (e.g. netperf::TCP_STREAM): guest->host, guest->host->guest,
guest->host->remote, host->remote, remote->host->guest

latency (e.g. netperf::UDP_RR): same conditions as throughput

cpu-utilization

others?

Ideally, this should be at least between upstream virtio and vhost.
Bonus points if you include venet as well.

Kind regards,
-Greg


--------------enig9CBB576151305611F6CF6CC2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrxpYcACgkQP5K2CMvXmqHHKQCfX0c8WoojuJe1A+eFFzu9twpU
PEkAn2bUMmeK9n8AfgWItG+bCqzjqtDQ
=6kXy
-----END PGP SIGNATURE-----

--------------enig9CBB576151305611F6CF6CC2--
