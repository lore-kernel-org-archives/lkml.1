Return-Path: <linux-kernel-owner+w=401wt.eu-S1752087AbYCLAad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbYCLAad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 20:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYCLAa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 20:30:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37283 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbYCLAa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 20:30:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: Suspend and hibernation patchset
Date: Wed, 12 Mar 2008 01:29:24 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Shaohua Li <shaohua.li@intel.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803120129.25585.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For everyone interested, I have put together a patchset containing some "fresh"
patches related to suspend and hibernation, on top of 2.6.25-rc5, located at:

http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.25-rc5/patches/

I have not yet decided what to do with patches 01-03.  Patch 03 will probably
be sent upstream soon.

Patch 04 is currently in the "test" branch of the ACPI tree and has been
tested already for some time in -mm and linux-next.

Patches 05-08, being mainly fixes, have just been sent upstream.

Patch 09, which I'm considering as the most important one, is the first of
a series that will introduce a new suspend and hibernation framework for
device drivers.  It introduces the highest-level structures and documents
them, so if you are planning any modifications in this area, have a look at it
and please let me know if there are any conflicts, so that we can avoid them.

Thanks,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
