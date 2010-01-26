Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823Ab0A0AII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab0A0AII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974Ab0A0AIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:08:06 -0500
Received: from kroah.org ([198.145.64.141]:35058 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab0AZXm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:42:56 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:21 2010
Message-Id: <20100126233921.099242955@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       H Hartley Sweeten <hsweeten@visionengravers.com>, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [02/98] clockevents: Add missing include to pacify sparse
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: H Hartley Sweeten <hartleys@visionengravers.com>

commit 8e1a928a2ed7e8d5cad97c8e985294b4caedd168 upstream.

Include "tick-internal.h" in order to pick up the extern function
prototype for clockevents_shutdown(). This quiets the following sparse
build noise:

  warning: symbol 'clockevents_shutdown' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
LKML-Reference: <BD79186B4FD85F4B8E60E381CAEE190901E24550@mi8nycmail19.Mi8.com>
Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: johnstul@us.ibm.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/clockevents.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -20,6 +20,8 @@
 #include <linux/sysdev.h>
 #include <linux/tick.h>
 
+#include "tick-internal.h"
+
 /* The registered clock event devices */
 static LIST_HEAD(clockevent_devices);
 static LIST_HEAD(clockevents_released);


