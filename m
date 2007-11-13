Return-Path: <linux-kernel-owner+w=401wt.eu-S1760654AbXKMSnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760654AbXKMSnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbXKMSnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:43:04 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:52197 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbXKMSnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:43:03 -0500
Message-Id: <20071113184248.434573812@polymtl.ca>
References: <20071113183923.190808360@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 13 Nov 2007 13:39:25 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 2/3] Linux Kernel Markers - Document format string
Content-Disposition: inline; filename=markers-document-markers-format-strings.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 13 Nov 2007 18:42:49 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Describes the format string standard further: Use of field names before the type
specifiers..

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 Documentation/markers.txt |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/Documentation/markers.txt
===================================================================
--- linux-2.6-lttng.orig/Documentation/markers.txt	2007-11-11 22:04:50.000000000 -0500
+++ linux-2.6-lttng/Documentation/markers.txt	2007-11-11 22:04:57.000000000 -0500
@@ -35,12 +35,14 @@ In order to use the macro trace_mark, yo
 
 And,
 
-trace_mark(subsystem_event, "%d %s", someint, somestring);
+trace_mark(subsystem_event, "myint %d mystring %s", someint, somestring);
 Where :
 - subsystem_event is an identifier unique to your event
     - subsystem is the name of your subsystem.
     - event is the name of the event to mark.
-- "%d %s" is the formatted string for the serializer.
+- "myint %d mystring %s" is the formatted string for the serializer. "myint" and
+  "mystring" are repectively the field names associated with the first and
+  second parameter.
 - someint is an integer.
 - somestring is a char pointer.
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
