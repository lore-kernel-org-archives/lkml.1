Return-Path: <linux-kernel-owner+w=401wt.eu-S1752698AbZJNRLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbZJNRLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 13:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbZJNRLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 13:11:53 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:45018 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbZJNRLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 13:11:52 -0400
Authentication-Results: sj-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAAOj1UqrRN+K/2dsb2JhbADCMphdhC4Eim0
X-IronPort-AV: E=Sophos;i="4.44,559,1249257600"; 
   d="scan'208";a="214464407"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, Bill Pemberton <wfp5p@virginia.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Staging: Comedi: Add missing <linux/sched.h> includes
X-Message-Flag: Warning: May contain useful information
Date: Wed, 14 Oct 2009 10:11:08 -0700
Message-ID: <adazl7taok3.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Oct 2009 17:11:08.0758 (UTC) FILETIME=[52730760:01CA4CF1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix fallout of removal of sched.h from interrupt.h.  This fixes build
breakage in staging drivers.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 drivers/staging/comedi/drivers/me_daq.c        |    1 +
 drivers/staging/comedi/drivers/ni_mio_common.c |    1 +
 drivers/staging/comedi/drivers/ni_pcidio.c     |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/comedi/drivers/me_daq.c b/drivers/staging/comedi/drivers/me_daq.c
index 2cda7ad..80e192d 100644
--- a/drivers/staging/comedi/drivers/me_daq.c
+++ b/drivers/staging/comedi/drivers/me_daq.c
@@ -51,6 +51,7 @@ from http://www.comedi.org
 */
 
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include "../comedidev.h"
 
 #include "comedi_pci.h"
diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index e3ffb06..753ee05 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -62,6 +62,7 @@
 /* #define DEBUG_STATUS_B */
 
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include "8255.h"
 #include "mite.h"
 #include "comedi_fc.h"
diff --git a/drivers/staging/comedi/drivers/ni_pcidio.c b/drivers/staging/comedi/drivers/ni_pcidio.c
index 52b2eca..d544698 100644
--- a/drivers/staging/comedi/drivers/ni_pcidio.c
+++ b/drivers/staging/comedi/drivers/ni_pcidio.c
@@ -70,6 +70,7 @@ comedi_nonfree_firmware tarball available from http://www.comedi.org
 /* #define DEBUG_FLAGS */
 
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include "../comedidev.h"
 
 #include "mite.h"
