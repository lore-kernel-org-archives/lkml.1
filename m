Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbZKJSAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbZKJSAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 13:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbZKJSAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 13:00:16 -0500
Received: from dovecot.org ([82.118.211.50]:48304 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbZKJSAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 13:00:15 -0500
Subject: Re: + prctl-add-pr_set_proctitle_area-option.patch added to -mm
 tree
From: Timo Sirainen <tss@iki.fi>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Bryan Donlan <bdonlan@gmail.com>, Ulrich Drepper <drepper@redhat.com>,
       WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <2f11576a0911100948o79970e44t197cd2978428de1a@mail.gmail.com>
References: <20091110170453.GA11771@redhat.com>
	 <2f11576a0911100948o79970e44t197cd2978428de1a@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+jTuS8eVu7XII7jjrYt/"
Date: Tue, 10 Nov 2009 13:00:16 -0500
Message-ID: <1257876016.3022.277.camel@timo-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+jTuS8eVu7XII7jjrYt/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-11-11 at 02:48 +0900, KOSAKI Motohiro wrote:
> There is unwritten reason. I hope to add /proc/[pid]/cmdline cache. It
> help to avoid
> ps getting stuck by mmap_sem.

Can you explain this further? When would it cache the value and when
would it be returned? I was at least hoping to avoid calling prctl()
every time when I want process title changed.

I think Solaris saves the first 80 chars of the initial cmdline to
kernel memory and gives that to ps. I guess doing something similar and
returning it only when userspace memory can't be accessed would be ok.


--=-+jTuS8eVu7XII7jjrYt/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkr5qi8ACgkQyUhSUUBVislS6QCfdLTMmgwEyVEsvJnOJ3KWlXTm
hsUAoI4FZoiIbPyqg8cEQSlfAdt7SvWZ
=llE7
-----END PGP SIGNATURE-----

--=-+jTuS8eVu7XII7jjrYt/--

