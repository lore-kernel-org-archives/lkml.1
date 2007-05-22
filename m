Return-Path: <linux-kernel-owner+w=401wt.eu-S934897AbXEVSPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934897AbXEVSPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 14:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757885AbXEVSOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 14:14:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756407AbXEVSOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 14:14:52 -0400
Message-ID: <46533314.10206@redhat.com>
Date: Tue, 22 May 2007 14:14:44 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: [stable] Wanted: Allow adding new device IDs during the -stable cycle
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to propose we allow adding new device IDs as part
of the -stable process, but only under certain conditions:

1) Each device (or group of devices) gets added as a separate
   patch, i.e. we don't just diff the device tables. This way
   each original patch that added the device(s) upstream will
   be become a single patch for -stable.

2) Devices that require new features/capabilities in their
   driver won't be added.

Candidate patches would be something like these, which together
add support for the ATI SB700 ATA controller:

1)
http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=823777181b4c0200923dcb026efa5b37f55c0ecf

Adds ATI sb700 quirk, using exactly the same one as sb600.

2)
http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2bcfdde6767f2f07891d2753c25220012fe5e6d2

Adds the new device to the existing driver's device ID table.

