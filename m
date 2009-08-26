Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbZHZU2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbZHZU2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbZHZU2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:28:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35943 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbZHZU1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:27:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "linux-pm" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/6] PM: Asynchronous suspend and resume of devices
Date: Wed, 26 Aug 2009 22:17:19 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200908262217.19609.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches introduce a mechanism allowing us to execute device
drivers' suspend and resume callbacks asynchronously during system sleep
transitions, such as suspend to RAM.

The idea is explained in the changelogs of the first two patches.

Comments welcome.

Thanks,
Rafael

