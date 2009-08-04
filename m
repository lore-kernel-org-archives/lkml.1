Return-Path: <linux-kernel-owner+w=401wt.eu-S933124AbZHDRZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124AbZHDRZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 13:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933100AbZHDRZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 13:25:32 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55569 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932923AbZHDRZb (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 13:25:31 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Greg KH <greg@kroah.com>
Cc: Pavel Machek <pavel@ucw.cz>, Zhang Rui <rui.zhang@intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 0/3] Generic sysfs support for ACPI ALS and other ALS devices
In-Reply-To: Your message of "Tue, 04 Aug 2009 08:10:42 PDT."
             <20090804151042.GA20276@kroah.com>
From: Valdis.Kletnieks@vt.edu
References: <1249290657.2670.250.camel@rzhang-dt> <20090804132129.GH18974@elf.ucw.cz>
            <20090804151042.GA20276@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1249406664_4151P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 04 Aug 2009 13:24:24 -0400
Message-ID: <19631.1249406664@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1249406664_4151P
Content-Type: text/plain; charset=us-ascii

On Tue, 04 Aug 2009 08:10:42 PDT, Greg KH said:
> On Tue, Aug 04, 2009 at 03:21:29PM +0200, Pavel Machek wrote:
> > On Mon 2009-08-03 17:10:57, Zhang Rui wrote:

> > > 	cat /sys/class/als/als0/mappings
> > > 	???Illuminance	Adjustment
> > > 	          0	       70
> > > 	         10	       73
> > > 	         80	       85
> > > 	        300	      100
> > > 	       1000	      150
> > 
> > There's one value per file for sysfs... You should definitely have the
> > header. 
> 
> No, no "header", just don't do this, it's not allowed. Again,
> one-value-per-sysfs-file is the rule, please do not violate it.

What's the intended sysfs solution here, then? Make 'mappings' a directory,
and populate it with files called 0, 10, 80, 300, 1000, each with one number
in them?

--==_Exmh_1249406664_4151P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKeG7IcC3lWbTT17ARAikQAJ9glOcEz+mjAUyhqyrpCnwzeceSCgCg5K00
4mFzLaxtgxRvJascRwKWlyw=
=Ko4l
-----END PGP SIGNATURE-----

--==_Exmh_1249406664_4151P--
