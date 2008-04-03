Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbYDCXQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbYDCXQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 19:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbYDCXQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 19:16:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34591 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbYDCXQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 19:16:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: [PATCH 0/3] PM: New suspend and hibernation callbacks
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Disposition: inline
Date: Fri, 4 Apr 2008 01:11:13 +0200
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200804040111.15255.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

The following patches are intended to start the redesign of the suspend and
hibernation framework for devices.

The first one introduces new callbacks for suspend and hibernation (7th revision).
It also updates the PM core to use the new callbacks at the top level, allowing
it to use the existing callbacks if the new ones are not defined.

The other two patches implement the new suspend and hibernation callbacks
for the platform and PCI bus types (3rd revision of both).

The patches allow platform and pci drivers to start using the new callbacks
immediately and similar patches for the other bus types etc. will follow.
Still, until drivers actually start to implement the new callbacks, no
functional changes are expected to appear as a result of these patches.

I think the patches have stabilized sufficiently for being pushed upstream,
so please add them to your queue.

Thanks,
Rafael

