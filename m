Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbZHLUVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbZHLUVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 16:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbZHLUVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 16:21:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59778 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904AbZHLUVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 16:21:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "linux-pm" <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 0/3] PM: Asynchronous suspend and resume
Date: Wed, 12 Aug 2009 22:18:13 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200908122218.13975.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches introduce a mechanism allowing us to execute device
drivers' suspend and resume callbacks asynchronously during system sleep
transitions, such as suspend to RAM.  The idea is explained in the [1/1] patch
message.

Comments welcome.

Thanks,
Rafael

