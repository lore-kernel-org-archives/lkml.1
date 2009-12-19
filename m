Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbZLSXa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbZLSXa7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 18:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbZLSXa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 18:30:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36064 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbZLSXa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 18:30:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PCI <linux-pci@vger.kernel.org>
Subject: [RFD] Asynchronous suspend/resume of PCI devices
Date: Sun, 20 Dec 2009 00:31:38 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912200031.38775.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd like to know your opinions about the viability of suspending and resuming
PCI devices asynchronously during system-wide PM transitions (suspend to RAM
and hibernation).

Linus says it's generally dangerous, because some PCI devices may indirectly
depend on the others, but if that's the case, I wonder if we really can power
manage PCI devices at run time.

It follows from my experiments that suspending and resuming PCI devices
asynchronously doesn't lead to problems as long as we make sure that every
PCI device is suspended before and resumed after its ACPI "shadow" partner.
However, I'm not sure if this is generally correct.

What are possible problems we can run into while doing asynchronous suspend
and resume of PCI devices?  What do we need to do in general to avoid that
problems?

Please tell me what you think.

Thanks,
Rafael
