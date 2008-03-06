Return-Path: <linux-kernel-owner+w=401wt.eu-S935076AbYCFSG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935076AbYCFSG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765194AbYCFSGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:06:10 -0500
Received: from tuxrocks.com ([208.78.103.217]:36291 "EHLO tuxrocks.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbYCFSGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:06:08 -0500
X-Greylist: delayed 2380 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2008 13:06:08 EST
Message-ID: <47D02940.1030707@tuxrocks.com>
Date: Thu, 06 Mar 2008 11:26:24 -0600
From: Frank Sorenson <frank@tuxrocks.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: 2.6.25-rc4 OOMs itself dead on bootup
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

2.6.25-rc4 invokes the oom-killer repeatedly when attempting to boot,
eventually panicing with "Out of memory and no killable processes."
This happens since at least 2.6.25-rc3, but 2.6.24 boots just fine,

The system is a Dell Inspiron E1705 running Fedora 8 (x86_64).

My .config is at http://tuxrocks.com/tmp/config-2.6.25-rc4, and a syslog
of the system up until the point where it oom-killed syslog (just before
the panic) is at http://tuxrocks.com/tmp/oom-2.6.25-rc4.txt


Frank
- --
Frank Sorenson - KD7TZK
Linux Systems Engineer, DSS Engineering, UBS AG
frank@tuxrocks.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFH0Ck9aI0dwg4A47wRAiE2AJ9fw0tRLtdnDrG7TdaR0721wj69owCgitR/
4XphvHdePCivYnu+gXFAgG8=
=shGl
-----END PGP SIGNATURE-----
