Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbYCQWSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbYCQWSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 18:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbYCQWS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 18:18:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44694 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbYCQWS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 18:18:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: Suspend and hibernation patchset against -rc6
Date: Mon, 17 Mar 2008 23:17:32 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Shaohua Li <shaohua.li@intel.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>
References: <200803120129.25585.rjw@sisk.pl>
In-Reply-To: <200803120129.25585.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803172317.33745.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 12 of March 2008, Rafael J. Wysocki wrote:
>
> For everyone interested, I have put together a patchset containing some "fresh"
> patches related to suspend and hibernation, on top of 2.6.25-rc5, located at:
> 
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.25-rc5/patches/

There's a new patchset against 2.6.25-rc6 at:

http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.25-rc6/patches/

It contains some more patches, specifically the "legacy PM removal" series, the
fixed "PM: make wakeup flags available whenever CONFIG_PM is set" series posted
recently by Alan (the second patch rebased by me), the Johannes' apm-emulation
patch and the patches introducing the new suspend/hibernation callbacks I sent
yesterday.

These remarks still apply:

> I have not yet decided what to do with patches 01-03.  Patch 03 will probably
> be sent upstream soon.
> 
> Patch 04 is currently in the "test" branch of the ACPI tree and has been
> tested already for some time in -mm and linux-next.

Also, patches 05-06 are upstream (in the Greg's tree).

Everything has been compiled and (lightly) tested on HP nx6325 and Asus L5D
(both 64-bit).

Thanks,
Rafael
