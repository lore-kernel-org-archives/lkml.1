Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbYFLSQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbYFLSQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 14:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbYFLSQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 14:16:33 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:43856 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYFLSQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 14:16:32 -0400
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240806121103m60a8ffa4ie11850fedc69d13c@mail.gmail.com> (sfid-20080612_200350_070282_410620E9)
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	 <20080612093833.0fb9cdd6@bree.surriel.com>
	 <1213278884.3936.15.camel@johannes.berg>
	 <1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com>
	 <1ba2fa240806120935r54a080eci7fa6fafc718eed17@mail.gmail.com>
	 <1213290335.3730.4.camel@johannes.berg>
	 <1ba2fa240806121039o376b0a8sdfaacf3a1f4a9e57@mail.gmail.com>
	 <1213292812.3730.21.camel@johannes.berg>
	 <1ba2fa240806121103m60a8ffa4ie11850fedc69d13c@mail.gmail.com>
	 (sfid-20080612_200350_070282_410620E9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-U4OPz3yRT6k4a6D7n97P"
Date: Thu, 12 Jun 2008 20:15:47 +0200
Message-Id: <1213294547.3730.29.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-U4OPz3yRT6k4a6D7n97P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I'm not against it. You;v decided that I'm fighting you because I gave
> another solution.

Ok, no, I'm not saying you shouldn't rewrite all the code to get rid of
it, but I think you can use a patch like mine interim as such a rewrite
is unlikely to go into 2.6.26, is it?

> Frankly we probably don't need this allocation at all. maybe one skb
> is just enough

That would be nice, indeed.

> even with my never dying hope all fragments are in skb fragment list.

:)

> This still probably won't save pci memory allocation problem

Yeah, true, that one needs to be done, but it could probably be done
only once when hw is probed rather than every time it is brought up.
Most likely not something you'll get to fix in 2.6.26 either though.

johannes

--=-U4OPz3yRT6k4a6D7n97P
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIUWfPAAoJEKVg1VMiehFYVdMQAIcF/vz8gbbAgfHRsBcxICfz
gP7ZeVxUXI3ZSMw5Kat9obrOjnd/l8HqNODD74k54IWz6RY4eiv+NWf4cbtEaPbG
x62fk5YVM+jviSC+WygdrMGjX6j1P2/qmzfUVV11vhImGqrky3Fj4TXsNMqvzlsC
oXQKmqrd2aq+T2AJRHjeiaN4y0eB5WFs/SuWjI6kuzaLtd0LJ0tKaOAIWXe+RWuy
GUD8GBZgH+pf1BtePP/wjQGFc40k/nD1PfAD8gKd/TqNebwvP6siJnylL4aSEX9v
MHLT5hJtIyqiDZAAjbp1sp4LOcmZZKPXMnO/0m9a3J5IwPe7Ks35CRBcWyqvH21x
W7mr6dBh7Spyy/2EBSBO+Fwy5UsYH5gi5qFAEu3wN/AV5K10K8PD/VUCfY3apfoJ
rDl7u6lFKD7hbfSXMXj8+kSdlE1JufawHl2GPX8HVvu9U0DtYoubk9q8tNdhr32/
Kbmw3OaZbKBCNXQ89nv6ZlCVMxZ7cFepq++wKr6zAlZxPleSZvfRhBVf4cxFWoZx
bNq2MuYBNlL+mDDxaf1Mv362ZcwILlUZsQTnncOQAHzf7wCLX4aqh50xamtqDx3x
/Jxgsf9Z2baBcwAtTwZegZImzW7ZahZxR1gZQwSWfKLSWnIgPcfj0UuSoU17niF/
M0aIidKP4TucC8+X62la
=2YL/
-----END PGP SIGNATURE-----

--=-U4OPz3yRT6k4a6D7n97P--

