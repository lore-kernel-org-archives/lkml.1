Return-Path: <linux-kernel-owner+w=401wt.eu-S1760583AbYDBAN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583AbYDBAN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 20:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758891AbYDBANR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 20:13:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49322 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757415AbYDBANL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 20:13:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 0/3] PM: Rework suspend and hibernation code for devices (rev. 4)
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>
MIME-Version: 1.0
Content-Disposition: inline
Date: Wed, 2 Apr 2008 02:07:39 +0200
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200804020207.40278.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the 4th revision of the patches intended to start the redesign of the suspend
and hibernation framework for devices, addressing (hopefully) all of the recent
comments.

Patch [1/3] is the 7th revision of the patch introducing new callbacks for
suspend and hibernation.

The other two patches implement the new suspend and hibernation callbacks
for the platform and PCI bus types (3rd revision of both).

The main differences between these patches and the previous revision:
* Dropped DPM_INVALID and made the PM core only report errors returned by
  resume callbacks, without handling them in any other way
* Updated the comments in pm.h accordingly
* Added a function for printing error messages to main.c

The platform and PCI patches are unchanged.

More comments welcome.

Thanks,
Rafael

