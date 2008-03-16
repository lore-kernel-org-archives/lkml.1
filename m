Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbYCPX0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbYCPX0V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 19:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYCPX0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 19:26:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37731 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbYCPX0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:26:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 0/3] PM: Rework suspend and hibernation code for devices
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Disposition: inline
Date: Mon, 17 Mar 2008 00:20:54 +0100
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200803170020.55473.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following three patches are intended to start the redesign of the suspend
and hibernation framework for devices.

The first patch defines the new framework.  Specifically, it introduces the
structure 'struct pm_ops' containing a set of hibernation and suspend
callbacks to be defined by bus types, device types, device classes and,
finally, by device drivers (the role of each callback is described in the
comment in pm.h; the documentation will be updated later).  It also modifies
the code in drivers/base/power/main.c to use the new framework, if available,
and fall back to the old one otherwise (no visible functional changes should be
added).

The other two patches implement the new suspend and hibernation callbacks
for the platform and PCI bus types.

Please review and tell me what you think.

Thanks,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

