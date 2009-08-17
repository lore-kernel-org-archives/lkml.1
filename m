Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbZHQAWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbZHQAWi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 20:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756523AbZHQAWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 20:22:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46008 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756326AbZHQAWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 20:22:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "linux-pm" <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 0/7] PM: Asynchronous suspend and resume (updated)
Date: Mon, 17 Aug 2009 02:15:21 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, Greg KH <gregkh@suse.de>
References: <200908122218.13975.rjw@sisk.pl>
In-Reply-To: <200908122218.13975.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908170215.21173.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 August 2009, Rafael J. Wysocki wrote:
> Hi,
> 
> The following patches introduce a mechanism allowing us to execute device
> drivers' suspend and resume callbacks asynchronously during system sleep
> transitions, such as suspend to RAM.  The idea is explained in the [1/1] patch
> message.

Changes:

* Added [1/7] that fixes kerneldoc comments in drivers/base/power/main.c
  (this is a 2.6.32 candidate).

* Added [2/7] adding a framework for representing PM link (idea described
  in the patch message).

* [3/7] is the async resume patch (idea described in the patch message).

* [4/7] is the async suspend patch.

* [5/7] - [7/7] set async_suspend for devices in a few selected subsystems.

The patches have been tested on HP nx6325.

Comments welcome.

Thanks,
Rafael

