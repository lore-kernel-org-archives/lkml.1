Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbXL0SCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbXL0SCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 13:02:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbXL0SBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 13:01:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43404 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbXL0SBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 13:01:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [RFC][PATCH 0/7] Fix the ACPI 1.0 vs ACPI 2.0 suspend ordering issue
Date: Thu, 27 Dec 2007 19:03:52 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Arjan van de Ven <arjan@infradead.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Moore, Robert" <robert.moore@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712271903.53961.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patchset is intended to fix the ACPI 1.0 vs ACPI 2.0 suspend
ordering issue described at http://bugzilla.kernel.org/show_bug.cgi?id=9528 and
in a recent LKML thread (http://lkml.org/lkml/2007/12/25/37).

The patches actually do more than that, as I think it's reasonable to untangle
some ACPI-specific suspend code by the way.  The details are described in the
changelogs.

The patches apply on top of the suspend branch of the ACPI tree
(git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6 suspend),
but they are also included in the quilt patch series at:
http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.24-rc6/patches/ .

Please review (and test, if possible).

Thanks,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

