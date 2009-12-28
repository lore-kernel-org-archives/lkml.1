Return-Path: <linux-kernel-owner+w=401wt.eu-S1752355AbZL1Q7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbZL1Q7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 11:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbZL1Q7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 11:59:06 -0500
Received: from exprod6og110.obsmtp.com ([64.18.1.25]:59019 "HELO
	exprod6og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751966AbZL1Q7F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 11:59:05 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] kernel/time/jiffies.c: local symbols should be static
Date: Mon, 28 Dec 2009 11:59:01 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F468@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] kernel/time/jiffies.c: local symbols should be static
Thread-Index: AcqH3w3IRI4T22IFR+SM9BPgy47hXQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <johnstul@us.ibm.com>
X-OriginalArrivalTime: 28 Dec 2009 16:59:01.0537 (UTC) FILETIME=[0DF92910:01CA87DF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol 'clocksource_jiffies' is not exported and should be static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: John Stultz <johnstul@us.ibm.com>

---

diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index 5404a84..36d2d83 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -55,7 +55,7 @@ static cycle_t jiffies_read(struct clocksource *cs)
 	return (cycle_t) jiffies;
 }
 
-struct clocksource clocksource_jiffies = {
+static struct clocksource clocksource_jiffies = {
 	.name		= "jiffies",
 	.rating		= 1, /* lowest valid rating*/
 	.read		= jiffies_read, 
