Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYHIVSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYHIVSi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 17:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbYHIVSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 17:18:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46883 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbYHIVS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 17:18:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Subject: [Regression] 2.6.27-rc2-git4: suspend and power off fails on Asus M3A32-MVP
Date: Sat, 9 Aug 2008 23:21:15 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, kernel-testers@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Frank Arnold <frank.arnold@amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808092321.16711.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Unfortunately, your commit 34ae7f35a21694aa5cb8829dc5142c39d73d6ba0
("[CPUFREQ][2/2] preregister support for powernow-k8") causes a power off/
suspend/ hibernation regression on my test box with the Asus M3A32-MVP
mainboard (AMD 790 chipset) and the Phenom 9850 CPU.

Apparently, the patch causes a crash in a CPU hotplug notifier to happen, but
I'm not really sure of that, since there are a lot of stack traces resulting
from it and I'm unable to capture them over a serial console.

It is sufficient to revert commit 34ae7f35a21694aa5cb8829dc5142c39d73d6ba0 to
make things work again.

Please advise.

Thanks,
Rafael
