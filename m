Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbYLIWXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbYLIWXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 17:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbYLIWW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 17:22:57 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:55633 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbYLIWW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 17:22:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=i/wGoLUSHcqogSbRYBRLZqzA3oAOT1ohjKq+lYzZloPK2rTrIxXx/h37ZisPO3iH8u
         Hf8ioYJT0IVs9KDh35IRhWMyQmg8EVvei+zIDMAXzAOYvK5yCqzvD/yB3g+czaGOWWbi
         Ppvtg85PF+uQEsxfghdMOrfsr+K6tQFEdKevI=
Message-ID: <493EEFB6.3080901@gmail.com>
Date: Tue, 09 Dec 2008 23:22:46 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 29/31] markers: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 samples/markers/probe-example.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/samples/markers/probe-example.c b/samples/markers/probe-example.c
index 2dfb3b3..d816aad 100644
--- a/samples/markers/probe-example.c
+++ b/samples/markers/probe-example.c
@@ -20,7 +20,7 @@ struct probe_data {
 	marker_probe_func *probe_func;
 };
 
-void probe_subsystem_event(void *probe_data, void *call_data,
+static void probe_subsystem_event(void *probe_data, void *call_data,
 	const char *format, va_list *args)
 {
 	/* Declare args */
@@ -37,9 +37,9 @@ void probe_subsystem_event(void *probe_data, void *call_data,
 	/* or count, check rights, serialize data in a buffer */
 }
 
-atomic_t eventb_count = ATOMIC_INIT(0);
+static atomic_t eventb_count = ATOMIC_INIT(0);
 
-void probe_subsystem_eventb(void *probe_data, void *call_data,
+static void probe_subsystem_eventb(void *probe_data, void *call_data,
 	const char *format, va_list *args)
 {
 	/* Increment counter */

