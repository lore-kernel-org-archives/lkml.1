Return-Path: <linux-kernel-owner+w=401wt.eu-S1761435AbXH0QO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761435AbXH0QO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759733AbXH0QFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:05:39 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:45175 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759473AbXH0QFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:05:36 -0400
Message-Id: <20070827160229.324564339@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 27 Aug 2007 12:02:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/2] Sort module list for /proc/modules seq file reads
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 27 Aug 2007 16:05:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here is the updated version of the module list sort for coherent seq file reads.
It includes, in the comments, a byte-by-byte test case that shows the race it
solves. It has been updated since the last post to make sure the byte-by-byte
read works correctly by using "pos" instead of m->private as position indicator.

Only /proc/modules is provided as a user, but it should eventually be used by
other kernel parts, such as kallsyms, to make sure they protect themselves from
list modification while they iterate on them.

It applies to 2.6.23-rc3-mm1.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
