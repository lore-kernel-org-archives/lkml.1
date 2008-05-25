Return-Path: <linux-kernel-owner+w=401wt.eu-S1760145AbYEYJ2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbYEYJ2d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 05:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbYEYJ2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 05:28:24 -0400
Received: from server.drzeus.cx ([85.8.24.28]:49557 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752969AbYEYJ2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 05:28:23 -0400
Date: Sun, 25 May 2008 11:27:28 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Subject: gcc "internal error" with 32-bit userspace, 64-bit kernel
Message-ID: <20080525112728.6341c113@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm having a bit of a problem with the x86 32-bit compatibility and I
don't really know how to debug it.

The problem is that gcc fails some builds with "internal error" when
I'm running a 32-bit userspace on a 64-bit kernel. The same test
scenario with a 32-bit kernel works fine.

More specifically, I'm using Red Hat's mock tool on Fedora 9 to build
packages. It sets up a chroot:ed environment where (as far as I can
tell) everything is from the target system. Building for 32-bit Fedora
8 succeeds, but not Fedora 9 or RHEL 5.

Ideas on how to proceed? From what I've read, the 32-bit compatibility
of the kernel should be 100%.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
