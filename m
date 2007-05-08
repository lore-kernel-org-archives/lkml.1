Return-Path: <linux-kernel-owner+w=401wt.eu-S934225AbXEHUnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934225AbXEHUnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933865AbXEHUn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:43:27 -0400
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120]:63433 "EHLO
	pne-smtpout3-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933740AbXEHUn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:43:26 -0400
X-Greylist: delayed 4184 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 May 2007 16:43:26 EDT
Message-ID: <4640CA5A.2080301@trn.iki.fi>
Date: Tue, 08 May 2007 22:07:06 +0300
From: Lasse Karkkainen <tronic+bpsk@trn.iki.fi>
User-Agent: Thunderbird 1.5.0.8 (X11/20061209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Slow usb-storage detection prevents RAID autodetection
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On boot, it takes a while until USB disks are detected, and before this
the kernel may have already reached the RAID autodetection stage (in
which case RAID arrays from USB storage will not be detected at all),
and may even have tried mounting the root, causing kernel panic if the
root partition was supposed to be on a USB disk.

Is there any good workaround for this besides using initrd? Or are there
plans on fixing it (perhaps make RAID autodetection and root mounting
wait for USB scanning to finish)?
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGQMpaOBbAI1NE8/ERAvXrAJ9db2FEaCMlXFpuduhz7LxUM8DJsACgt75R
YFmRRJog2LyIcqMttYxCJ/A=
=v0DG
-----END PGP SIGNATURE-----
