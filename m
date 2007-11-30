Return-Path: <linux-kernel-owner+w=401wt.eu-S932983AbXK3Gl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983AbXK3Gl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 01:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbXK3GlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 01:41:12 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:59475 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbXK3GlK (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 01:41:10 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Zhao Yakui <yakui.zhao@intel.com>
Cc: Dave Young <hidave.darkstar@gmail.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: pnpacpi : exceeded the max number of IO resources
In-Reply-To: Your message of "Fri, 30 Nov 2007 10:21:28 +0800."
             <1196389288.19722.29.camel@yakui_zhao.sh.intel.com>
From: Valdis.Kletnieks@vt.edu
References: <a8e1da0711290111m65b071cft90b4361ec0155096@mail.gmail.com> <a8e1da0711291718u4161e650g1ee7eb88243ed9a4@mail.gmail.com>
            <1196389288.19722.29.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196404859_4697P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 30 Nov 2007 01:40:59 -0500
Message-ID: <22018.1196404859@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196404859_4697P
Content-Type: text/plain; charset=us-ascii

On Fri, 30 Nov 2007 10:21:28 +0800, Zhao Yakui said:
> Thanks for the acpidump & dmesg.
> 	In the acpidump there are so many IO resource definitions in the device
> of mem2 and the number exceeds the predefined number(24).

On a semi-related note, I'm seeing 7 of these at each boot on a Dell Latitude D820:

pnpacpi: exceeded the max number of mem resources: 12

2.6.24-rc3-mm2 does it, it didn't do it for 2.6.23-mm1.

pnp-increase-the-maximum-number-of-resources.patch raised it from 4 to 12, but
I don't understand why it didn't complain at 4 in 23-mm1, but it does at 12 now.



--==_Exmh_1196404859_4697P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHT7B7cC3lWbTT17ARAnccAKDXBem1FgHM9a2Jp+hdxH3/QzcnoQCgkBYb
AqUQk5oEZ1KhucDkKl0U4ww=
=mBU/
-----END PGP SIGNATURE-----

--==_Exmh_1196404859_4697P--
