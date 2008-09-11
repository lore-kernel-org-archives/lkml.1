Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbYIKS37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbYIKS37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 14:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYIKS3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 14:29:50 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:38985 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbYIKS3t (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 14:29:49 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Tejun Heo <htejun@gmail.com>
Cc: Elias Oltmanns <eo@nebensachen.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] libata: Implement disk shock protection support
In-Reply-To: Your message of "Thu, 11 Sep 2008 15:01:00 +0200."
             <48C9168C.4090101@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <87wshzplvk.fsf@denkblock.local> <20080829211345.4355.89284.stgit@denkblock.local> <48B913E6.1000104@gmail.com> <87k5dym5t9.fsf@denkblock.local> <48BA638B.2030001@gmail.com> <87ej45mlp3.fsf@denkblock.local> <48BA969C.4060207@gmail.com> <87abetmaap.fsf@denkblock.local> <48BBA8D1.8020604@gmail.com> <87myirly1p.fsf@denkblock.local> <48BC1BB8.2030007@gmail.com> <87fxoh0yil.fsf@denkblock.local> <48BFA528.2040305@gmail.com> <87ej3zrf3o.fsf@denkblock.local> <48C0F2F8.1040308@gmail.com> <87ej3snm3s.fsf@denkblock.local> <48C7DC55.30002@gmail.com> <8763p3ol55.fsf@denkblock.local> <48C82CB1.2070308@gmail.com> <871vzrogpz.fsf@denkblock.local> <48C850AA.2030409@gmail.com> <87k5diq35g.fsf@denkblock.local> <48C91458.7090503@gmail.com>
            <48C9168C.4090101@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1221157727_3036P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 11 Sep 2008 14:28:47 -0400
Message-ID: <25227.1221157727@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1221157727_3036P
Content-Type: text/plain; charset=us-ascii

On Thu, 11 Sep 2008 15:01:00 +0200, Tejun Heo said:
> Ah.. just one more thing.
> 
> I think it would be easier on the application if the written timeout
> value is cropped if it's over the maximum instead of failing the
> write.

Which is better, failing the write so the application *knows* there is a
problem, or letting the application proceed with a totally incorrect idea of
what the value is set to?

For instance, what happens if the program tries to set 100, it's silently
clamped to 10, and it then tries to set a timer for itself to '90% of the
value'?  It might be in for an unpleasant surprise when it finds out that
it's overshot by 81....



--==_Exmh_1221157727_3036P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIyWNfcC3lWbTT17ARAqTZAKCdEfSXq66RnOT1tp9K+i/t3W0zAwCfbPLd
OobtSFbKqKU1U9DBKFYRQbc=
=NPqv
-----END PGP SIGNATURE-----

--==_Exmh_1221157727_3036P--
