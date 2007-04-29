Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbXD2QqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbXD2QqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 12:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbXD2QqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 12:46:15 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:35727 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424AbXD2QqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 12:46:13 -0400
Date: Sun, 29 Apr 2007 18:45:53 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: mm snapshot broken-out-2007-04-28 uploaded
Message-ID: <Pine.LNX.4.61.0704291842410.22744@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,


in broekn-out-2007-04-28 I get:

(`make allnoconfig; make menuconfig` on i386...)

drivers/net/Kconfig:2327:warning: 'select' used by config symbol 
'UCC_GETH' refer to undefined symbol 'UCC_FAST'

grepping for it in the patches points me to git-powerpc.patch. Now that 
is a big one patch for git-side changes, which makes it a little harder 
to find out who put in that UCC_FAST. Please Cc the appropriate person, 
thanks!


Jan
-- 
