Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbXDVKGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbXDVKGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 06:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965620AbXDVKGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 06:06:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:44688 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025AbXDVKGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 06:06:08 -0400
Date: Sun, 22 Apr 2007 10:06:05 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.35-pre3
Message-ID: <20070422100605.GA5918@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Back to 2.4... I've just released Linux 2.4.35-pre3.

We're getting closer to 2.4.35. It is in good shape, and the major
change I was most afraid of (e1000 driver update) works like a charm.
Kudos to intel people on this one !

I will still have to see whether the skge/sky2 drivers are stable
enough to be kept, or if we can either update them or if I'll have
to revert them. I've encountered some trouble with sky2 that I could
mostly fix by backporting other fixes, so I'll have to decide what to
do with it.

I'm observing a slight trend of updates from people in the embedded
world. I encourage those people to continue to propose their changes
so that we can judge whether they will be needed in 2.6 too. It's an
area where it is quite common to secretly keep fixes and drivers, so
whatever can be done to collect all the work already done on 2.4 is
worth it.

BTW, please note that the changes under my name below are not from me
but fixes that I had to backport from 2.6.

Regards,
Willy

The patch and changelog will appear soon at the following locations:
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/testing/
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.35-pre3.bz2
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.35.log

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/linux-2.4.git
  http://www.kernel.org/pub/scm/linux/kernel/git/wtarreau/linux-2.4.git/

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/wtarreau/linux-2.4.git


Summary of changes from v2.4.35-pre2 to v2.4.35-pre3
============================================

Adrian Bunk (1):
      init/main.c: remove comment that gcc 4 was not supported

Alexey Korolev (1):
      Linux 2.4.x MTD CFI P30/P33 support

Tal Kelrich (2):
      2.6 backport of Watchdog wdt83627 (Winbond W83627HF/F/HG/G) driver
      Watchdog w83977ef (Winbond W83977EF) driver

Willy Tarreau (6):
      [DECNet] fib: Fix out of bound access of dn_fib_props[]
      [IPv4] fib: Fix out of bound access of fib_props[]
      [PPP]: Don't leak an sk_buff on interface destruction.
      Fix TCP receiver side SWS handling
      [Bluetooth] Fix L2CAP and HCI setsockopt() information leaks (CVE-2007-1353)
      Change VERSION to v2.4.35-pre3

