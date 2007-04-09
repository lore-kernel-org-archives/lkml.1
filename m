Return-Path: <linux-kernel-owner+w=401wt.eu-S932929AbXDINm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbXDINm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 09:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932933AbXDINm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 09:42:28 -0400
Received: from h80ad276f.async.vt.edu ([128.173.39.111]:43020 "EHLO
	h80ad276f.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932929AbXDINm1 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 09:42:27 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Eric Sandeen <sandeen@redhat.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Add a norecovery option to ext3/4?
In-Reply-To: Your message of "Sun, 08 Apr 2007 22:24:50 CDT."
             <4619B202.3050601@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <20070409000556.GA13980@implementation>
            <4619B202.3050601@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1176126139_28267P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 09 Apr 2007 09:42:19 -0400
Message-ID: <7641.1176126139@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1176126139_28267P
Content-Type: text/plain; charset=us-ascii

On Sun, 08 Apr 2007 22:24:50 CDT, Eric Sandeen said:
> Can you elaborate?  Under what circumstances is log replay going to harm 
> data?  Do you mean that the installer mounts partitions, looking for 
> what OS is installed?  How is that harmful?

Another usage case that really wants to avoid the log replay is if you're
looking at an unknown disk image with a forensics CD such as Helix:

http://www.e-fense.com/helix/

Yes, good forensics always clones the disk image twice (the first clone being
used for nothing but creating second-gen clones for analysis), and in most
cases the forensic analyst can work around the fact that you *do* cause some
changes to the disk image by mounting.  But sometimes, you'd rather be looking
at a possibly inconsistent image than replaying the log  - particularly if
you're looking at a "seized and power plug pulled" image, and you actually
care about things that may have been in the log, like just-erased files. 

--==_Exmh_1176126139_28267P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGGkK7cC3lWbTT17ARAroiAKD8wEmjkMS2sBrfaagLOUsvioKjcwCgsczw
tZjWjCpax3vEhjl+Cl41ktE=
=g6KH
-----END PGP SIGNATURE-----

--==_Exmh_1176126139_28267P--
