Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbZD2V2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbZD2V2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 17:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZD2V2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 17:28:03 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:51514 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbZD2V2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 17:28:01 -0400
Subject: Re: Regression since 2.6.30-rc1 - Page allocation failures
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1241039372.4547.3.camel@johannes.local> (sfid-20090429_231009_993152_4FF82E4D)
References: <49F8C03D.6040909@lwfinger.net>
	 (sfid-20090429_230225_847074_E5413886)  <1241039372.4547.3.camel@johannes.local>
	 (sfid-20090429_231009_993152_4FF82E4D)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-U+kMGZbeVcrLtj67qhtO"
Date: Wed, 29 Apr 2009 23:27:31 +0200
Message-Id: <1241040451.5067.0.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-U+kMGZbeVcrLtj67qhtO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-04-29 at 23:09 +0200, Johannes Berg wrote:

> 	"%d, %d, need %d, %d", skb->data_len, skb->len, head_need, tail_need

actually, I think I want

	skb_tail_pointer(skb) - skb->head

instead of skb->data_len.

johannes

--=-U+kMGZbeVcrLtj67qhtO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ+MY5AAoJEKVg1VMiehFYU60P/0knKG8sxITEALjb9y1exVqA
W5UgpTqmfzZmSNEr5x4eJ6bwZr9CiiSREeuC0jOF0zksjchX8UHQBuMPGOxK2l6b
fD3D7tlIA0cwMebumM02xRKY4jb8qmFhjSSoWIR3ISe8LU6ydjBWvSV5D5Ksh4S/
JClCqCa6oynebej9PkTjiAzWZ3XkxTFNc+AiCE6lQQ6BbGEEYP62rDyMNKtJ79jT
CzqvKcJVxKc9NRMLA/XvQT9NJQwTPEe0ExTAu1ZBKjZZhYjDrdRxsynYTRlqWvu5
XDvjQ+1tK57/YVXgQiAZYePsu/TrjwhVoRgNz1J1oWmLp6JR2t4nNl9zJg8F8AJc
q14uQ/jbwAGNLsKCVKzX8V1vWLRxL1bSjkPNe9J7xwF8DD36o5hYegpcSOMi2AK4
sYrU1nsfinXDMGKUeKrKbdCy6QEcPyMbn3HVCkUnNhIpnHZKv1pWXmtTVKco08so
q6PkP/jbzoBgNTmJRIDHWTqrkizeDx2X3D7c89l2jrlqTs/k/Icn+abKfJHQ7klt
R/anWSgkVo3Vwnwp2yK6IqyPzOfbiKaplQR46Z/K6pciWOWHTIE6ZAHlhO+dBh1L
NvSzpsy+S7OoY8EgrzLI5sBbA2JSnHYpiWVAVSkGyswTLFajNS/8sVkb9q1f7W+1
hfUBxAHB2WR4gL2xiUBc
=5J/U
-----END PGP SIGNATURE-----

--=-U+kMGZbeVcrLtj67qhtO--

