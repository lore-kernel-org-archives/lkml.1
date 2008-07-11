Return-Path: <linux-kernel-owner+w=401wt.eu-S1760029AbYGKUTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760029AbYGKUTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbYGKUTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:19:08 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43798 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbYGKUTG (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:19:06 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Marcin Obara <marcin_obara@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Marcel Selhorst <tpm@selhorst.net>, Kylene Jo Hall <kjhall@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: patch tpm-correct-tpm-timeouts-to-jiffies-conversion.patch breaks stuff
In-Reply-To: Your message of "Fri, 11 Jul 2008 21:39:52 +0200."
             <ea8d860a0807111239u2d8318d0k74312f6b74ebc06a@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <18107.1215803534@turing-police.cc.vt.edu>
            <ea8d860a0807111239u2d8318d0k74312f6b74ebc06a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1215807507_7279P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 11 Jul 2008 16:18:27 -0400
Message-ID: <48384.1215807507@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1215807507_7279P
Content-Type: text/plain; charset=us-ascii

On Fri, 11 Jul 2008 21:39:52 +0200, Marcin Obara said:
> 2008/7/11  <Valdis.Kletnieks@vt.edu>:
> 
> >
> > So is the spec wrong, or is my chipset on drugs, or?
> >
> Can you provide configuration information?
> - used TPM chip
> - used TPM kernel modules

This is on a Dell Latitude D820 with an x86_64 2.6.25-rc8-mm kernel.

% lsmod | grep tpm
tpm_tis                11660  0 
tpm                    13760  1 tpm_tis
tpm_bios                6464  1 tpm

dmesg says:

tpm_tis 00:0f: 1.2 TPM (device-id 0x1001, rev-id 2)

and lspnp -v says:

00:0f BCM0102 TPM chipset
    state = active
        mem 0xfed40000-0xfed44fff
        io 0xcb0-0xcbb

(Yes, I'm confused why it's BCM0102 and not BCM0101)..


--==_Exmh_1215807507_7279P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFId8ATcC3lWbTT17ARAjptAKDmgWs7Pt0YspaIa8wFFlkCn91HkgCeJTpR
M0/e8s/hVs98ANFTV+/LfbE=
=GGog
-----END PGP SIGNATURE-----

--==_Exmh_1215807507_7279P--
