Return-Path: <linux-kernel-owner+w=401wt.eu-S935577AbZLPTUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935577AbZLPTUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935273AbZLPTUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:20:36 -0500
Received: from quamquam.org ([88.198.196.3]:54479 "EHLO quamquam.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763143AbZLPTUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:20:12 -0500
X-Greylist: delayed 1345 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Dec 2009 14:20:12 EST
Message-ID: <4B292D9A.5060501@poelzi.org>
Date: Wed, 16 Dec 2009 19:57:30 +0100
From: Daniel Poelzleithner <poelzi@poelzi.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Suggestion: xtime as new inode attribute
X-Enigmail-Version: 0.95.7
OpenPGP: id=0A7B003D;
	url=http://files.poelzi.org/poelzi.asc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 92.116.241.212
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: poelzi@poelzi.org
X-SA-Exim-Scanned: No (on quamquam.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

I would like to suggest a new attribute for inodes in linux filesystems
to record the last execution time of files.

The problem:

If a linux installation gets older and older, more and more programs get
installed over time. Mostly to just test them for a particular problem
and often the deinstallation is forgotten. To find out which packages
are not used for a long time is currently quite impossible. The user may
use program X which will run but not depend on program Y as a subprocess
for example.

The solution:

I suggest a new inode attribute called xtime, which is like atime, but
will only be updated when a file is executed. This would allow tracking
of unused binaries and could be used with some clever algorithms in the
cleanup program to find unused packages for removal or other cleanup
purposes.
It would also add an additional information in forensic analysis of
hacked systems btw.

Please CC me, I'm not on the list.

kindly regards
 Daniel Poelzleithner
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJLKS2ZAAoJEFYpgV2RoepczcwQAMEyN63uJd0nW5YMgVn2sxL6
DcHJVnKjxyN31FDJhJcQynn9yvHhFmOMFNQdzKoa4AYwJxBnwlhqtflUt+lkucFo
Bw9WylnKH48tbh4jOpSb6yD7aZd23MIAcGZtF1/cKR7l+UvMpxWhBAKtulJ5mAzm
xKc4M5ItjyAO+mArdgpUO/3hsFUHvG6ufN487njHiLDMDrNc6HVg8nsxVsZvZOXf
7AioGb+M08lkqoG6TLTWXttx9jrKTFJY0/cubMpb3VmCEdFfU1GdQ9eUPCAkPxcJ
zDFrCG2d9Q/mYGuOUWW7kOE8IMPciNWoWuT/BhFD3mW9V1up37hUug7M5TT+QCC3
ypU9Go5eLVtSJbLEUHXR1QOg/vOVCfWTBioSX0tBJTcy2YkNrp7kgQOFgOQtkTKO
GgIN49Y0qiHvyVjy/G40d1rkso312aWpYJqtsDgG78yKW0nPMOUej0p5BTrAvIHu
uR2dzm92SHyt+llGj/I+K6MACrt10iGqmjIEFov1bXiTAyuUbnoKVCD+0jvi1PqV
029Fy8O8ESjmkNlssrNT7DNYPEDoV8Sn5HZbtJr7nxdhefCSn6J7euOGJdiTHfM4
E0mwcGsSGsLaF+XV1tg50RWbIOXFw1fdtbvLvdKbgM6PXxhvSBJBOS2qVIAyqf2u
O4uD9rjGwvmMYSv8HvuD
=EddF
-----END PGP SIGNATURE-----
