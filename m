Return-Path: <linux-kernel-owner+w=401wt.eu-S1759534AbXH0QDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534AbXH0QDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758238AbXH0P64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:58:56 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:43126 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758670AbXH0P6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:58:54 -0400
Message-Id: <20070827155601.360241608@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 27 Aug 2007 11:56:01 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 00/10] Text Edit Lock
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 27 Aug 2007 15:58:50 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here is the updated version of the Text Edit Lock for 2.6.23-rc3-mm1. It
provides architecture agnostic synchronization for code patching and deals with
i386/x86_64 modification of RO pages by clearing the WP bit around memory
writes.

It is useful for alternatives, paravirt, kprobes and, eventually, immediate
values.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
