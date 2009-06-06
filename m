Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbZFFXBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbZFFXBP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 19:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbZFFXBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 19:01:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57066 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbZFFXA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 19:00:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 0/2] PM: Rearrange core suspend code
Date: Sun, 7 Jun 2009 00:54:18 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906070054.19207.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's something I wanted to do quite some time ago.

kernel/power/main.c becomes more and more difficult to maintain over time,
since it contains both the suspend to RAM core code and some common PM code
that is also used for hibernation.  For this reason [1/2] separates the suspend
to RAM code from main.c and puts it into two new files (the test facility is,
again, separated from the core code for clarity).

[2/2] renames kernel/power/disk.c to kernel/power/hibernate.c, because the role
of this file is analogous to kernel/power/suspend.c (introduced by [1/2]).

Comments welcome.

Best,
Rafael

