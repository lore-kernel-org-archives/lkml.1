Return-Path: <linux-kernel-owner+w=401wt.eu-S1752144AbZHBOTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbZHBOTt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 10:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbZHBOTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 10:19:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36611 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbZHBOTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 10:19:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Wilcox <willy@linux.intel.com>
Subject: [Regression] PCI resources allocation problem on HP nx6325
Date: Sun, 2 Aug 2009 16:19:47 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908021619.48285.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

As reported at

http://bugzilla.kernel.org/show_bug.cgi?id=13891

there is a problem with allocating PCI resources on HP nx6325 introduced by
your commit a76117dfd687ec4be0a9a05214f3009cc5f73a42
(x86: Use pci_claim_resource).

On this particular box it causes the audio adapter's PCI memory space to
be allocated for something else.

Kernel messages from the failing kernel and from the kernel with commit
a76117dfd687ec4be0a9a05214f3009cc5f73a42 reverted, as well as the corresponding
contents of /proc/iomem and /proc/ioports, are attached to the Bugzilla entry.

Thanks,
Rafael
