Return-Path: <linux-kernel-owner+w=401wt.eu-S1751537AbZJPW0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbZJPW0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 18:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbZJPW0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 18:26:20 -0400
Received: from exprod6ob113.obsmtp.com ([64.18.1.30]:34841 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750781AbZJPW0T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 18:26:19 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] jiffies.c: fix symbol was not declared noise
Date: Fri, 16 Oct 2009 18:26:22 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901E24552@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] jiffies.c: fix symbol was not declared noise
Thread-Index: AcpOr7CfYxxVaqWsRS28sgYF14x1pA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Oct 2009 22:26:23.0176 (UTC) FILETIME=[B125AC80:01CA4EAF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel/time/jiffies.c, clocksource_jiffies should be static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

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
