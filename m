Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbYDMRjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbYDMRjM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYDMRi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:38:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36344 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbYDMRi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:38:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: Suspend and hibernation patchset against -rc9
Date: Sun, 13 Apr 2008 19:39:13 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Shaohua Li <shaohua.li@intel.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>, Ingo Molnar <mingo@elte.hu>
References: <200803120129.25585.rjw@sisk.pl> <200803270051.31778.rjw@sisk.pl> <200804020227.12943.rjw@sisk.pl>
In-Reply-To: <200804020227.12943.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804131939.14965.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For everyone interested, there's a new suspend/hibernation patchset against
2.6.25-rc8 at:
  
http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.25-rc9/patches/
 
It contains one new patch picked up from -mm,
gregkh-driver-power_state-remove-it-from-driver-core.patch , that patch 16 is
based on.

I still have not decided what to do with patches 01-03.  Patch 03 will probably 
be sent upstream.

A new version of patch 04 has recently been included into the x86 git tree and
before it had been tested in -mm and linux-next for quite some time.

Patches 05-11 and 13 are in the Greg's tree and have been tested in -mm and
linux-next.
  
Patch 12 is in the ACPI test tree and has been tested in -mm and linux-next.

Patches 16-18 are the 5th revision of the patchset introducing new suspend and
hibernation callbacks for drivers.  They are in -mm and have just been resent to
Greg.

Thanks,
Rafael
