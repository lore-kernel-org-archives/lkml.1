Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbZIYXZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbZIYXZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 19:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZIYXZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 19:25:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54679 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760AbZIYXZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 19:25:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/2] PM / PCMCIA: Fix CardBus suspend/resume regression
Date: Sat, 26 Sep 2009 01:22:58 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-pcmcia@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Florian <fs-kernelbugzilla@spline.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909260122.59030.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following two patches fix a regression causing CardBus resume to fail,
introduced during the 2.6.29 development cycle.

[1/2] Drops the second argument of pcmcia_socket_dev_suspend(), which is not
      used.

[2/2] Fixes the regression by moving the yenta suspend/resume to the late phase
      of suspend and early phase of resume, respectively.

If there are no objections, I'll push these patches through the suspend-2.6
tree early next week.

Thanks,
Rafael

