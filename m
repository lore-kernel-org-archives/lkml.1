Return-Path: <linux-kernel-owner+w=401wt.eu-S933409AbXFRWFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409AbXFRWFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765659AbXFRWF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:05:28 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:49609 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764552AbXFRWF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:05:27 -0400
Message-Id: <20070618215846.247539382@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 18 Jun 2007 17:58:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Chuck Ebbert <cebbert@redhat.com>, prasanna@in.ibm.com, ananth@in.ibm.com,
       jkenisto@us.ibm.com, ak@suse.de
Subject: [patch 0/3] Text Section Edit Lock
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 18 Jun 2007 22:04:59 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This code adds locking around text section modifications. It can be used by
paravirt/alternatives, kprobes and eventually the immediate values to:

A - synchronize dynamic code patching
B - make sure the pages are writable

I only provided the i386 version, but it could be easily ported to other
architectures.

It applies at the end of the 2.6.22-rc4-mm2 series in the following order:

text-edit-lock-i386.patch
text-edit-lock-alternative-i386.patch
text-edit-lock-kprobes-i386.patch

Comments are welcome, (testing is welcome too)

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
