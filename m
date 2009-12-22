Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbZLVWCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbZLVWCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 17:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbZLVWCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 17:02:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47496 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbZLVWCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 17:02:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] PM fixes and updates for 2.6.33
Date: Tue, 22 Dec 2009 23:03:05 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc1-tst; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912222303.05698.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management fixes and updates for 2.6.33 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus

They include:

* Fix for commit f2511774863487e61b56a97da07ebf8dd61d7836
  (PM: Add initcall_debug style timing for suspend/resume)
  adding the timing instrumentation for devices that haven't been switched
  to struct dev_pm_ops yet.

* Total device suspend and resume time reporting.

* Runtime PM core fix from Alan Stern.

* Runtime PM enhancement allowing the core to call device type or device
  class callbacks if bus type callbacks are not defined.

* Runtime PM documentation update from Alan Stern.


 Documentation/power/runtime_pm.txt |  223 ++++++++++++++++++++++--------------
 drivers/base/power/main.c          |  128 +++++++++++++++++----
 drivers/base/power/runtime.c       |   45 +++++++
 3 files changed, 288 insertions(+), 108 deletions(-)

---------------

Alan Stern (2):
      PM: Use pm_runtime_put_sync in system resume
      PM: Runtime PM documentation update

Rafael J. Wysocki (3):
      PM: Make the initcall_debug style timing for suspend/resume complete
      PM: Measure device suspend and resume times
      PM / Runtime: Use device type and device class callbacks

