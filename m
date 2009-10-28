Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbZJ1WsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbZJ1WsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 18:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbZJ1WsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 18:48:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45068 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbZJ1WsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 18:48:21 -0400
Date: Wed, 28 Oct 2009 23:48:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>, Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>
Subject: staging/dream: add TODO file
Message-ID: <20091028224817.GA13987@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds TODO list. It is probably incomplete, as many parts were not
reviewed by the upstream maintainers, yet.

Signed-off-by: Pavel Machek <pavel@ucw.cz>


diff --git a/drivers/staging/dream/TODO b/drivers/staging/dream/TODO
new file mode 100644
index 0000000..38fd221
--- /dev/null
+++ b/drivers/staging/dream/TODO
@@ -0,0 +1,14 @@
+* remove support for wakelocks since those are not in mainline
+
+* camera driver uses old V4L API
+
+* coding style in some places is lacking
+
+* gpio_input.c has some features matrix_keypad lacks. They should be
+merged to gpio_input, with gpio_input.c removed
+
+* pmem provides interface for userspace. Needs to be reviewed at least.
+
+* it is probably possible to simplify touchscreen driver using threaded_irq's.
+
+* touchscreen driver should be switched to oficial multitouch API

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
