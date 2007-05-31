Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbXEaOpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbXEaOpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 10:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbXEaOpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 10:45:36 -0400
Received: from tuxrocks.com ([63.99.9.217]:38947 "EHLO tuxrocks.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752459AbXEaOpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 10:45:35 -0400
Message-ID: <465EDF89.9050207@tuxrocks.com>
Date: Thu, 31 May 2007 09:45:29 -0500
From: Frank Sorenson <frank@tuxrocks.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, jeff@garzik.org
Subject: Combined mode quirk removal kills performance
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The patch to "remove combined mode quirk" (git bisect says
8cdfb29c0cd8018f92214c11c631d8926f4cb032) makes my laptop run slower
than a dead sloth.  "hdparm -T" indicates that buffered disk reads on my
hard drive drop from 48-50 MB/sec to 1-2MB/sec, and the system is nearly
unusable.

System is a Dell Inspiron E1705 (Core 2 Duo 2.16GHz) running x86_64 FC6.

Frank
- --
Frank Sorenson - KD7TZK
Linux Systems Engineer, DSS Engineering, UBS AG
frank@tuxrocks.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGXt+JaI0dwg4A47wRAqJmAJ4k4E9ekkitOdQ72HUXbky11nD1cACghGu6
y7Y71PPaKHYcQhYSfL55bNk=
=MPYY
-----END PGP SIGNATURE-----
