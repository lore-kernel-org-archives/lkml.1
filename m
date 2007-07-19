Return-Path: <linux-kernel-owner+w=401wt.eu-S939526AbXGSP5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939526AbXGSP5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761316AbXGSP5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:57:31 -0400
Received: from tim.rpsys.net ([194.106.48.114]:33566 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204AbXGSP5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:57:30 -0400
Subject: MMC/SD Root filesystem suspend/resume problems
From: Richard Purdie <rpurdie@rpsys.net>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 19 Jul 2007 16:53:39 +0100
Message-Id: <1184860419.29634.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

Lots of Linux handhelds use MMC/SD devices as the root file system. This
has worked quite reliably for many kernel versions. In 2.6.22, it seems
that if you suspend such a system then resume it, the device locks up.
Trying to execute anything on the filesystem results in a "Permission
Denied" message. I did see a message from the MMC subsystem saying it
had redetected the card. There are also messages on the console like
"MMC: killing requests for dead queue" each time you suspend/resume.

I'm away from my serial cables at the moment but I may be able to
provide more debug when I have them over the weekend. Have you any ideas
on why this is breaking?

For reference, I've reproduced the problem with both the PXA host driver
and different driver not merged into mainline (ASIC3).

Cheers,

Richard

