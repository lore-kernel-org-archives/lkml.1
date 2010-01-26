Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635Ab0AZWUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab0AZWUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 17:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677Ab0AZWUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 17:20:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab0AZWUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 17:20:42 -0500
Date: Tue, 26 Jan 2010 17:20:41 -0500
From: Don Zickus <dzickus@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: Fwd: [scripts] python: change scripts to use system python instead
 of env
Message-ID: <20100126222041.GR4472@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doh. Typo in the To: field

----- Forwarded message from Don Zickus <dzickus@redhat.com> -----

Date: Fri, 22 Jan 2010 16:32:10 -0500
From: Don Zickus <dzickus@redhat.com>
To: lkml@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, tony.luck@intel.com,
	kmcmartin@redhat.com, Don Zickus <dzickus@redhat.com>
Subject: [scripts] python: change scripts to use system python instead of env
Message-Id: <1264195930-15815-1-git-send-email-dzickus@redhat.com>

Just a small change to a couple of scripts to go from

 #!/usr/bin/env python

to

 #!/usr/bin/python

This shouldn't effect anyone, unless they don't install python there.

In preparation for python3, Fedora is doing a big push to change the scripts
to use the system python.  This allows developers to put the python3 in
their path without fear of breaking existing scripts.

Now I am pretty sure anyone using python3 for testing purposes will probably
not run any of the scripts I changed, but Fedora has this automated tool
that checks for this stuff so I thought I would try to push it upstream.

Signed-off-by: Don Zickus <dzickus@redhat.com>

--
I don't do enough python to defend this change to much other than it seems
to make sense.
---
 arch/ia64/scripts/unwcheck.py  |    2 +-
 scripts/rt-tester/rt-tester.py |    2 +-
 scripts/show_delta             |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/scripts/unwcheck.py b/arch/ia64/scripts/unwcheck.py
index c278498..2bfd941 100644
--- a/arch/ia64/scripts/unwcheck.py
+++ b/arch/ia64/scripts/unwcheck.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/python
 #
 # Usage: unwcheck.py FILE
 #
diff --git a/scripts/rt-tester/rt-tester.py b/scripts/rt-tester/rt-tester.py
index 4c79660..44423b4 100644
--- a/scripts/rt-tester/rt-tester.py
+++ b/scripts/rt-tester/rt-tester.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/python
 #
 # rt-mutex tester
 #
diff --git a/scripts/show_delta b/scripts/show_delta
index 48a706a..17df305 100755
--- a/scripts/show_delta
+++ b/scripts/show_delta
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/python
 #
 # show_deltas: Read list of printk messages instrumented with
 # time data, and format with time deltas.
-- 
1.6.6.83.gc9a2


----- End forwarded message -----
