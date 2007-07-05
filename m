Return-Path: <linux-kernel-owner+w=401wt.eu-S1761538AbXGETNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761538AbXGETNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 15:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760286AbXGETM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 15:12:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54898 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760211AbXGETM7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 15:12:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 0/2] PM: Update system power off code
Date: Thu, 5 Jul 2007 21:12:29 +0200
User-Agent: KMail/1.9.5
Cc: Len Brown <len.brown@intel.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707052112.30548.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following two patches update the system power off code.  They:
* remove the (unnecessary) call to acpi_sleep_prepare(ACPI_STATE_S4) from
  acpi_shutdown()
* remove acpi_sysclass and device_acpi that are only defined to register the
  ACPI power off preparation callback in acpi_shutdown() and introduce more
  general mechanism instead

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

