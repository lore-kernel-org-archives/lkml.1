Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbXJJTqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbXJJTqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 15:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbXJJTq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 15:46:26 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51249 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbXJJTqZ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 15:46:25 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: TPM driver changes to support multiple locality
In-Reply-To: Your message of "Tue, 09 Oct 2007 15:51:11 PDT."
             <A3258B497F1C1441AD36A2E8B45FD628C7D657@scsmsx412.amr.corp.intel.com>
From: Valdis.Kletnieks@vt.edu
References: <A3258B497F1C1441AD36A2E8B45FD628C7D657@scsmsx412.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1192045583_2784P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 10 Oct 2007 15:46:23 -0400
Message-ID: <27383.1192045583@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1192045583_2784P
Content-Type: text/plain; charset=us-ascii

On Tue, 09 Oct 2007 15:51:11 PDT, "Agarwal, Lomesh" said:
> Current TPM driver supports only locality 0. I am planning to add
> support so that it can access any locality. Locality parameter will be
> passed as parameter. Will this change be acceptable? If yes then I will
> modify the driver and send the patch.

Make sure you extend the API in such a way that older userspace programs
that don't pass the new locality parameter still work correctly.

--==_Exmh_1192045583_2784P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHDSwPcC3lWbTT17ARAklbAKClsuI8z5mhyzpXMqdrWjX136rFdgCg7vjP
e53TQCVURc6NtLK9KlyEajk=
=nIqg
-----END PGP SIGNATURE-----

--==_Exmh_1192045583_2784P--
