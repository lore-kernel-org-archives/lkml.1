Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbYILSMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbYILSMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 14:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbYILSMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 14:12:36 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:58035 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbYILSMf (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 14:12:35 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] libata: Implement disk shock protection support
In-Reply-To: Your message of "Fri, 12 Sep 2008 12:15:22 +0200."
             <87prn9y8jp.fsf@denkblock.local>
From: Valdis.Kletnieks@vt.edu
References: <87wshzplvk.fsf@denkblock.local> <48BA969C.4060207@gmail.com> <87abetmaap.fsf@denkblock.local> <48BBA8D1.8020604@gmail.com> <87myirly1p.fsf@denkblock.local> <48BC1BB8.2030007@gmail.com> <87fxoh0yil.fsf@denkblock.local> <48BFA528.2040305@gmail.com> <87ej3zrf3o.fsf@denkblock.local> <48C0F2F8.1040308@gmail.com> <87ej3snm3s.fsf@denkblock.local> <48C7DC55.30002@gmail.com> <8763p3ol55.fsf@denkblock.local> <48C82CB1.2070308@gmail.com> <871vzrogpz.fsf@denkblock.local> <48C850AA.2030409@gmail.com> <87k5diq35g.fsf@denkblock.local> <48C91458.7090503@gmail.com> <48C9168C.4090101@gmail.com> <48C9A8D3.60408@gmail.com>
            <87prn9y8jp.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1221243065_3046P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 12 Sep 2008 14:11:05 -0400
Message-ID: <22453.1221243065@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1221243065_3046P
Content-Type: text/plain; charset=us-ascii

On Fri, 12 Sep 2008 12:15:22 +0200, Elias Oltmanns said:
> Tejun Heo <htejun@gmail.com> wrote:

> > How about returning -OVERFLOW while still setting the timeout to the
> > maximum?
> 
> Yes, that makes sense. I'll take care to document it that way:
> -EINVAL for values < -2, -EOVERFLOW for values > 30000.

Works for me...

--==_Exmh_1221243065_3046P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIyrC5cC3lWbTT17ARAk8HAJ9O0pfSzivSX+KHjAb6frDlMtndKQCgzyv5
reFo7zzbGd508tqVfUyPTd4=
=iC1B
-----END PGP SIGNATURE-----

--==_Exmh_1221243065_3046P--
