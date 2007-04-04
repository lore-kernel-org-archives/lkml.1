Return-Path: <linux-kernel-owner+w=401wt.eu-S966286AbXDDCLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966286AbXDDCLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966287AbXDDCLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:11:31 -0400
Received: from h80ad26a7.async.vt.edu ([128.173.38.167]:53496 "EHLO
	h80ad26a7.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966286AbXDDCLb (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:11:31 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Brad Boyer <flar@allandria.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
In-Reply-To: Your message of "Tue, 03 Apr 2007 16:09:08 PDT."
             <20070403230908.GA13471@cynthia.pants.nu>
From: Valdis.Kletnieks@vt.edu
References: <1175610345.2665.15.camel@shinybook.infradead.org> <17938.57292.870224.132415@cargo.ozlabs.ibm.com> <1175642916.10567.24.camel@shinybook.infradead.org> <20070403212928.GA12951@cynthia.pants.nu> <1175644642.10567.31.camel@shinybook.infradead.org> <20070403221002.GA13210@cynthia.pants.nu> <1175648051.10567.61.camel@shinybook.infradead.org>
            <20070403230908.GA13471@cynthia.pants.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1175652638_3426P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 03 Apr 2007 22:10:38 -0400
Message-ID: <7641.1175652638@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1175652638_3426P
Content-Type: text/plain; charset=us-ascii

On Tue, 03 Apr 2007 16:09:08 PDT, Brad Boyer said:

> an abstraction of "serial port" as far as the user is concerned. On
> Solaris, I can say "/dev/term/a" and know that I will get the first
> serial port if it is available without needing to care if it is the
> zs, se or asy driver talking to the hardware.

This is fine if you're trying to boot and find your system console.

It blows complete chunks if the port you're trying to find is the
first port on the special serial card that supports speeds above 115kbaud
because we have a real-time constraint, and even at 115k you fall short
on the timing budget (actual real-life issue we hit on an SGI running IRIX
a number of years ago. Blowing the budget often resulted in a 3,000 pound
motion base to turn into a 3,000 pound jackhammer:

http://www.sv.vt.edu/future/cave/resprj/crane/crane_thor/2001FebReport.html
http://www.moog.com/Media/1/6D2000E500-395_1102.pdf

--==_Exmh_1175652638_3426P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGEwkecC3lWbTT17ARAt+/AJsEXZc092CXe711oEorreqIhQ1lgwCgt3oe
G2HMPG6AlTfyN9KI/MszxWM=
=UDo1
-----END PGP SIGNATURE-----

--==_Exmh_1175652638_3426P--
