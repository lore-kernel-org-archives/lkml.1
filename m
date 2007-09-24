Return-Path: <linux-kernel-owner+w=401wt.eu-S1758784AbXIXQ5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784AbXIXQ5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760183AbXIXQ4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:56:46 -0400
Received: from mail.nagafix.co.uk ([194.145.196.85]:41028 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757610AbXIXQ4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:56:45 -0400
Message-ID: <46F7EC47.9010803@nagafix.co.uk>
Date: Mon, 24 Sep 2007 17:56:39 +0100
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20070806)
MIME-Version: 1.0
To: tytso@thunk.org, Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: bug in fsck or ext2/ext3?
X-Enigmail-Version: 0.95.2
OpenPGP: id=F18AD6BB;
	url=http://users.nagafix.co.uk/~antoine/antoine.asc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hi Ted / LKML,

I've got this snapshot of an ext3 filesystem with a directory that
simply cannot be removed! (image below is just 1.2MB)
As root:
# wget http://users.nagafix.co.uk/~antoine/root-broken.bz2
# bunzip2 root-broken.bz2
# mount -o loop -t ext2 root-broken ./tmp
# rm -fr tmp/chroot.broken
rm: cannot remove directory (...)
Same result when trying to do anything to those files chown/chmod/touch:
"Operation not permitted"

Tested with e2fsprogs v1.39 on 3 systems.
Not sure where else to post this...

Cheers
Antoine
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG9+xHGK2zHPGK1rsRCn6/AJ0S9/D1LTTxsi69uVovKRURa1fFhACfcEzx
8I6nOimUYCFKh9oX6ebnLc0=
=FhTL
-----END PGP SIGNATURE-----
