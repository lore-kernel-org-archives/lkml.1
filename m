Return-Path: <linux-kernel-owner+w=401wt.eu-S934038AbYBBUki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038AbYBBUki (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756400AbYBBUka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:40:30 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:41051 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656AbYBBUk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:40:29 -0500
Message-Id: <20080202203722.628843686@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 02 Feb 2008 15:37:22 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/3] Kprobes mutex cleanup
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat,  2 Feb 2008 20:40:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset cleans the kprobes mutexes. It makes usage of the Text Edit Lock
possible.

It applies on top of 2.6.24-git12 in this order :

kprobes-use-mutex-for-insn-pages.patch
kprobes-dont-use-kprobes-mutex-in-arch-code.patch
kprobes-declare-kprobes-mutex-static.patch

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
