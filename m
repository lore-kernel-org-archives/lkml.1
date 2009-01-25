Return-Path: <linux-kernel-owner+w=401wt.eu-S1751518AbZAYUqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbZAYUqo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 15:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbZAYUqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 15:46:33 -0500
Received: from coding-badger.net ([88.191.17.171]:53676 "EHLO
	sd-1367.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbZAYUqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 15:46:33 -0500
Message-ID: <497CCF9B.6000102@yahoo.fr>
Date: Sun, 25 Jan 2009 21:46:19 +0100
From: strawks <strawks@yahoo.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
CC: Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: hdb: status error: error=0x40 <3>{ UncorrectableError }
References: <3f9a31f40901251239k3e368feeib33661d82497725b@mail.gmail.com>
In-Reply-To: <3f9a31f40901251239k3e368feeib33661d82497725b@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jaswinder Singh Rajput wrote:
> Hello all,
>
> I added extra IDE drive I get similar messages like below so I replace
> it another drive but I am still getting similar error messages on
> 2.6.29-rc2-tip:

Does it work with other kernels?

> hdb: status error: status=0x59 { DriveReady SeekComplete DataRequest
Error }
> hdb: status error: error=0x40 <3>{ UncorrectableError },
> LBAsect=208845, sector=0
> ide: failed opcode was: unknown
> end_request: I/O error, dev hdb, sector 0
> Buffer I/O error on device hdb, logical block 0
> hdb: drive not ready for command
[...]
> How can I fix these error.

What is the output of :

smartctl -A -l error /dev/hdb

- --
regards,
strawks
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkl8z5sACgkQ+2TXLlA5m78D6QCbBkiQDwjQXiGcP9DNVJiI236P
KaoAnilCy2jHOGap4tHTDEwFFI9CZPD2
=BkrH
-----END PGP SIGNATURE-----
