Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbZBCTTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbZBCTTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 14:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756029AbZBCTTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 14:19:11 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:45126 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755650AbZBCTTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 14:19:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArEEAEwiiElMQWt2/2dsb2JhbACBbs4ehBQG
Date: Tue, 3 Feb 2009 14:18:47 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: LTTng 0.91 optimizes data copy primitives
Message-ID: <20090203191847.GA27522@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:59:40 up 33 days, 18:57,  5 users,  load average: 0.47, 0.18,
	0.14
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just released LTTng 0.91 in which I've had a 20% performance increase
when tracing in flight recorder mode when compiling a kernel by creating
an inlined optimized (memcpy-less for 1, 2, 4, and 8 bytes) fast path
for the low-level data copy primitive.

Here is the commit :

http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=commit;h=5bb4bb6814709fd35bcefcd460da3c66b0f639fb

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
