Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab0CIKhC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 05:37:02 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46593 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab0CIKg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 05:36:58 -0500
Date: Tue, 9 Mar 2010 21:36:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: [PATCH] i2c: update for semaphore to mutex conversion of
 devices
Message-Id: <20100309213650.e22c9908.sfr@canb.auug.org.au>
In-Reply-To: <20100309092508.02b7b2e8@hyperion.delvare>
References: <20100309102828.18351564.sfr@canb.auug.org.au>
	<20100309092508.02b7b2e8@hyperion.delvare>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Mar_2010_21_36_50_+1100_06QQL=blL0FrhfkV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Mar_2010_21_36_50_+1100_06QQL=blL0FrhfkV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

On Tue, 9 Mar 2010 09:25:08 +0100 Jean Delvare <khali@linux-fr.org> wrote:
>
> Thanks for the reminder Stephen. I was only waiting for device_lock()
> to become usable in mainline. Now that it happened, I will take the
> patch above in my i2c tree, and send it to Linus in my next batch.

Thanks.  The include of mutex.h is not actually needed yet as Greg didn't
send the semaphore to mutex change to Linus due to other issues.  The
device_lock/unlock part would be useful, though for when the change does
happen.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Mar_2010_21_36_50_+1100_06QQL=blL0FrhfkV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuWJMIACgkQjjKRsyhoI8zwWwCdGe7S3qjIVAPbDSAWwQp6gw3n
3XoAn32Xdx5RDEacX8sHUTTccrPTDlDz
=vbXo
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Mar_2010_21_36_50_+1100_06QQL=blL0FrhfkV--
