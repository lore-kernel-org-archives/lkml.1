Return-Path: <linux-kernel-owner+w=401wt.eu-S1756975AbYILPZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbYILPZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 11:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbYILPZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 11:25:35 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40188 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbYILPZe (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 11:25:34 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Marcin Obara <marcin_obara@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, tpm@selhorst.net, kjhall@us.ibm.com,
       linux-kernel@vger.kernel.org, srajiv@linux.vnet.ibm.com,
       debora@linux.vnet.ibm.com
Subject: Re: tpm-correct-tpm-timeouts-to-jiffies-conversion.patch -> 2.6.27
In-Reply-To: Your message of "Thu, 11 Sep 2008 12:03:52 +0200."
             <ea8d860a0809110303g68d7cf2fs7affd9103abc9b24@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <48C84619.8030303@gmail.com> <20080910152258.762e3714.akpm@linux-foundation.org>
            <ea8d860a0809110303g68d7cf2fs7affd9103abc9b24@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1221189008_3204P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 11 Sep 2008 23:10:08 -0400
Message-ID: <7218.1221189008@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1221189008_3204P
Content-Type: text/plain; charset=us-ascii

On Thu, 11 Sep 2008 12:03:52 +0200, Marcin Obara said:

> > Why?  I wasn't aware that this fixed anything which anyone had observed
> > (pokes tongue out at the changelog).
> >
> 
> This fixes i.e.: long hang while loading TPM driver, if TPM chip
> starts in "Idle" state instead of "Ready" state.
> Without this patch - 'modprobe' may hang for 30 seconds or more.
> Please, push this patch into 2.6.27.

I personally don't care whether this goes into .27 or waits till .28.  However,
I *would* appreciate it if we make sure that whenever it goes go upstream, we
also send tpm-work-around-bug-in-broadcom-bcm0102-chipset.patch at the same
time.

I have to admit that it's not exactly confidence inspiring - if the Broadcom
chip gets timeout units wrong, what *other* issues lurk in its silicon?  It's
bad enough when you find bugs in a RAID chipset or mouse hardware - it's even
worse when it's a security chip.. ;)



--==_Exmh_1221189008_3204P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIyd2QcC3lWbTT17ARAsZuAJ9JVGVrbFeCtplzeQESYH157OVjBQCg5Ucs
Sru0nV13kCo5QBbnrhO39nY=
=Lwsc
-----END PGP SIGNATURE-----

--==_Exmh_1221189008_3204P--
