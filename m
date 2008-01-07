Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbYAGVcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbYAGVcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 16:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758336AbYAGVco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 16:32:44 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34151 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbYAGVcn (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 16:32:43 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Zhao Yakui <yakui.zhao@intel.com>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org
Subject: Re: pnpacpi: exceeded the max number of IO resources: 24
In-Reply-To: Your message of "Mon, 07 Jan 2008 13:07:28 +0800."
             <1199682448.2379.12.camel@yakui_zhao.sh.intel.com>
From: Valdis.Kletnieks@vt.edu
References: <200712240612.46786.elendil@planet.nl> <1198803416.21142.7.camel@yakui_zhao.sh.intel.com> <200801070048.19468.elendil@planet.nl>
            <1199682448.2379.12.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1199741560_2703P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 07 Jan 2008 16:32:40 -0500
Message-ID: <21603.1199741560@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1199741560_2703P
Content-Type: text/plain; charset=us-ascii

On Mon, 07 Jan 2008 13:07:28 +0800, Zhao Yakui said:

> The resources of PNP device are obtained by calling the _CRS method.
> Maybe some resources has been reserved. For example: Some system will
> reserve the following resources.
>    BIOS-e820: 00000000fec00000 - 00000000fed40000 (reserved)
>    BIOS-e820: 00000000fed45000 - 0000000100000000 (reserved)
> So the system will report that some resources can't be reserved.
...
> The error message is harmless. It only tells us that the resource
> definition of PNP device exceeds the predefined PNP constant and maybe
> there will be potential problem if some important resources can't be
> reserved. For example about 90 IOPORT resources are defined in some PNP
> device. So it will print the message. Of course it is more appropriate
> to change the message level from ERR to DEBUG. 

Is it possible to add some cookie crumbs to the currently non-informative
message - things like "what address range", "what PNP devices' _CRS was
asking for it", and so on?



--==_Exmh_1199741560_2703P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHgpp4cC3lWbTT17ARAlaVAKCIG+iyWB0Oibca8zc6TcuvaW/RywCgnFG7
d4m/t/CHsF554T1Kr/nfNHI=
=gzmH
-----END PGP SIGNATURE-----

--==_Exmh_1199741560_2703P--
