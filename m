Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbXGFNpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbXGFNpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 09:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbXGFNpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 09:45:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58491 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbXGFNpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 09:45:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 0/2] PM: Optional beeping during resume from suspend to RAM
Date: Fri, 6 Jul 2007 15:49:04 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <ak@suse.de>,
       Len Brown <len.brown@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707061549.04952.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following two patches:
* add a feature allowing the user to make the system beep during a resume from
  RAM on i386 and x86_64 (useful for users with broken resume, so that they can
  check if the control reaches the kernel after a wake-up event)
* integrate the new feature with the existing acpi_sleep flags
* fix acpi_sleep_setup so that the order of parameters in the command line does
  not matter.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

