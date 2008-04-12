Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbYDLPMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbYDLPMW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 11:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbYDLPMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 11:12:15 -0400
Received: from wp093.webpack.hosteurope.de ([80.237.132.100]:42497 "EHLO
	wp093.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752736AbYDLPMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 11:12:14 -0400
Message-ID: <4800D14C.8020209@nuuz.at>
Date: Sat, 12 Apr 2008 17:12:12 +0200
From: Marcus Nutzinger <marcus@nuuz.at>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Greg KH <greg@kroah.com>
Subject: Re: Kernel BUG at fs/sysfs/file.c:552
References: <47FCCDB7.9070203@nuuz.at> <20080412043139.GB13154@kroah.com>
In-Reply-To: <20080412043139.GB13154@kroah.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;marcus@nuuz.at;1208013134;7281de6e;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

> With the nvidia driver, you're not going to get much help on this list
> :(

Well I don't like the driver either but the problem is really totally
unrealted I think..

> Hm, did you create two files with the same name?

No I only wanted to create one file on the first try, just to test the
sysfs interface. It should only give an attribute under /sys/devices,
called "writer_pid", which prints 0 or an actual PID of a process
writing to my virtual device.

I've just tried some other stuff just this minute and now it seems to
work, I get a directory under /sys/devices! Unfortunately I can't say
what the real problem was and why this kernel bug occured...

But I've another question: This directory doesn't only contain the
attribute ("writer_pid") which I've created in the code, but also a
subdirectory "power" and another attribute "uevent".. Could you explain
to me what's this all about? Are these just standard attributes which
are added to every device which registers there? (Sounds obviousely
because other directories under my /sys/devices tree contain them too..).

> Care to post your code?

I've uploaded it to http://www.nuuz.at/temp/vdd.c. I didn't want to post
the whole code here, I hope that's ok!

thanks for replying,
regards
Marcus Nutzinger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIANFMeEFjZ1Jaui4RAlbfAJ9XzbidhogUUMexqhuc/YPMzIaAjgCdGEtA
0NtTj7FkOfpaYdXQZklTlf0=
=FmIo
-----END PGP SIGNATURE-----
