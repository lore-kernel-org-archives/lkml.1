Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbYIXOmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbYIXOmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 10:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbYIXOmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 10:42:42 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:35178 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbYIXOmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 10:42:42 -0400
Message-ID: <48DA51EA.80408@novell.com>
Date: Wed, 24 Sep 2008 08:42:50 -0600
From: John Jolly <jjolly@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: axboe@kernel.dk
CC: Jan Blunck <JBlunck@novell.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] block: installing include/linux/blktrace_api.h
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

From: John Jolly <jjolly@novell.com>

Added line to install include/linux/blktrace_api.h during 'make headers_install'

Signed-off-by: John Jolly <jjolly@novell.com>
CC: Jan Blunck <JBlunck@novell.com>
- ---
 include/linux/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index b68ec09..f1e5fa1 100644
- --- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -41,6 +41,7 @@ header-y += baycom.h
 header-y += bfs_fs.h
 header-y += blkpg.h
 header-y += bpqether.h
+header-y += blktrace_api.h
 header-y += can.h
 header-y += cdk.h
 header-y += chio.h
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkjaUeoACgkQdLWlL2z7PiVIogCgtT+z9KQOhY5eza8EoU/O0hKp
XG4AnROtNWlScQA+em7tVxuA9H+22/6Q
=b3Pe
-----END PGP SIGNATURE-----
