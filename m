Return-Path: <linux-kernel-owner+w=401wt.eu-S965018AbXHLPQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965018AbXHLPQq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936538AbXHLPK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:10:57 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47791 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936531AbXHLPKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:10:55 -0400
Message-Id: <20070812150844.305211039@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 11:08:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/2] Sorted seq_file
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 15:10:39 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

I ran in a race regarding seq_file listing of modules. Here is a fix proposed to
get a coherent output even if modules are being unloaded at the same time.

It is needed by the linux kernel markers.

It applies on top of 2.6.23-rc2-mm2 in this order:

seq_file_sorted.patch
module.c-sort-module-list.patch


Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
