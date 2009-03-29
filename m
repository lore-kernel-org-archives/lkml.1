Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbZC2QWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbZC2QWN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbZC2QV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:21:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:17577 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZC2QV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:21:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=OiAsodN32p9VR+TuJBK6CXvWMQ0/7qoc7w+/KVC8H18F0TFjvEjjvQ8HrYYOXA5iLn
         +K7AdZ0jS1w0RqsdMBzYYVxWiT0CpiUIf7l6/ODBp6QqgPJuDh51p39HXEZp/uqQ0IRu
         pk52t8svjjPk+JZIFxXM+X05+IxWINVl/WVs0=
Date: Sun, 29 Mar 2009 20:21:51 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: otus: remove old irqreturn_t definition
Message-ID: <20090329162151.GL11056@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See commit bedd30d9 (genirq: make irqreturn_t an enum)

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/otus/zdcompat.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/otus/zdcompat.h b/drivers/staging/otus/zdcompat.h
index 8acf400..d9a3b2d 100644
--- a/drivers/staging/otus/zdcompat.h
+++ b/drivers/staging/otus/zdcompat.h
@@ -45,13 +45,6 @@ struct iw_request_info
 #endif
 #endif
 
-#ifndef IRQ_NONE
-typedef void irqreturn_t;
-#define IRQ_NONE
-#define IRQ_HANDLED
-#define IRQ_RETVAL(x)
-#endif
-
 #ifndef in_atomic
 #define in_atomic()  0
 #endif
