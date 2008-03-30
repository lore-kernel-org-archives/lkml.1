Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbYC3Sjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbYC3Sjg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 14:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbYC3Sj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 14:39:26 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:46472 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbYC3Sj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 14:39:26 -0400
Date: Sun, 30 Mar 2008 20:39:18 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>
Subject: some PCI reads makes machine lock up
Message-ID: <20080330203918.6878589e@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got a really weird bug report where loading the sdhci driver makes
the machine lock up. Some further debugging revealed that simple reads
into the device's address space causes the problem (reads that aren't
supposed to trigger any activity). To make things even more confusing,
it's the pattern of the reads, not reading specific registers.

As my knowledge of the low level PCI stuff is very limited, I was
hoping that someone with more expertise could have a look at it and
suggest some things to test.

The bug is in the kernel bugzilla here:

http://bugzilla.kernel.org/show_bug.cgi?id=9905

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
