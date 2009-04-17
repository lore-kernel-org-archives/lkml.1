Return-Path: <linux-kernel-owner+w=401wt.eu-S1761000AbZDQAp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761000AbZDQAp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760842AbZDQAkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:40:42 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:57934 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760715AbZDQAkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:40:41 -0400
Message-Id: <20090417001437.215128284@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 16 Apr 2009 20:14:37 -0400
From: mathieu.desnoyers@polymtl.ca
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [patch 0/3] Tracepoints kill rcupdate header dependency
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 17 Apr 2009 00:38:23 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a patch to remove the tracepoint rcupdate dependency by splitting the
read-side primitives of rcupdate.h into a sub rcupdate_defines.h header. That
should make, at least, pvops tracing easier.

It applies on top of current tip/tracing/ftrace tree.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
