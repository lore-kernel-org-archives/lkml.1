Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab0BAVU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 16:20:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:47565 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894Ab0BAVUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 16:20:54 -0500
Date: Mon, 1 Feb 2010 21:20:53 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.37.9
Message-ID: <20100201212053.GA20012@hera.kernel.org>
Reply-To: w@1wt.eu
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Feb 2010 21:20:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've just released Linux 2.4.37.9.

Jesse Brandeburg notified me that the e1000 backport in 2.4.37.8
was broken (e1000_main.c was not committed). I don't know how I
managed to do that because it once was OK and I could successfully
build it. Well, whatever I did, the result is wrong and the issue
it was supposed to fix is still present in 2.4.37.8. So here comes
2.4.37.9 with the real fix this time. It was built, booted (runs
on my file server at the moment) and re-checked after the final
commit. Please use that one instaed of 2.4.37.8.

Sorry for the confusion, and many thanks to Jesse for his careful
review!

Willy
--

The patch and changelog will appear soon at the following locations:
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/patch-2.4.37.9.bz2
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.37.9

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.37.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.37.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.4.37.y.git



Summary of changes from v2.4.37.8 to v2.4.37.9
============================================

Willy Tarreau (2):
      e1000: enhance frame fragment detection (again)
      Change VERSION to 2.4.37.9

