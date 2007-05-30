Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbXE3OIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbXE3OIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbXE3OIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:08:21 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48243 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930AbXE3OIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:08:20 -0400
Message-Id: <20070530140359.006540666@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 30 May 2007 10:03:59 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/6] Linux Kernel Markers - for 2.6.22-rc2-mm1
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 30 May 2007 14:07:12 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the port of the Linux Kernel Markers for 2.6.22-rc2-mm1. It depends on
the conditional calls infrastructure.

I took account of Sam Ravnborg's comments about EXTRARW_DATA in this patch.

It applies at the end of the 2.6.22-rc2-mm1 series, after the conditional call
patches, in the following order :

use-extra_rwdata-in-architectures.patch
linux-kernel-markers-architecture-independent-code.patch
linux-kernel-markers-hash-table.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-port-blktrace-to-markers.patch

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
