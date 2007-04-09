Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbXDIXW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbXDIXW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 19:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbXDIXW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 19:22:59 -0400
Received: from outbound.mse3.exchange.ms ([69.25.50.242]:53981 "EHLO
	outbound.mse3.exchange.ms" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753644AbXDIXW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 19:22:58 -0400
X-Greylist: delayed 847 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Apr 2007 19:22:58 EDT
Message-ID: <461AC795.7080303@centeris.com>
Date: Mon, 09 Apr 2007 16:09:09 -0700
From: Marcin Krzysztof Porwit <mporwit@centeris.com>
Reply-To: mporwit@centeris.com
Organization: Centeris Corporation
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: non-blocking io from kernel to user space
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Apr 2007 23:08:50.0728 (UTC) FILETIME=[09278280:01C77AFC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

I'm trying to find examples of the kernel doing a non-blocking upcall to
userspace while processing a request. None of the kernel books really
get into this, so I'm hoping someone can just point me at an existing
example.

In this case, what I'm looking to do is call up to winbindd to get some
credentials for a user while the kernel is handling a mount request.

Thanks for any info.
- --
Marcin Krzysztof Porwit
mporwit@centeris.com

#include <stddisclaimer.h>
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGGseV4OZU6cX5VBERAjceAJ9IPuMxujrzRCMHmQLuwj1lIerAUgCeOdCh
ymMgN+KqAo0Gzya3iihgtBw=
=TSXw
-----END PGP SIGNATURE-----
