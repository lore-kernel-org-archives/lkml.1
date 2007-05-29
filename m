Return-Path: <linux-kernel-owner+w=401wt.eu-S1762310AbXE2OHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762310AbXE2OHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760870AbXE2OCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 10:02:52 -0400
Received: from tayrelbas03.tay.hp.com ([161.114.80.246]:59133 "EHLO
	tayrelbas03.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760835AbXE2OCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 10:02:51 -0400
Date: Tue, 29 May 2007 06:48:14 -0700
From: Stephane Eranian <eranian@frankl.hpl.hp.com>
Message-Id: <200705291348.l4TDmEOR019606@frankl.hpl.hp.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 00/22] 2.6.22-rc3 perfmon2 : introduction
Cc: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Perfmon2 is a new kernel subsystem which provides access to the
hardware performance counters of modern processors. It supports
basic counting and sampling on a per-thread or system-wide basis.
Most major processor architectures are supported.

The following series of patches includes the perfmon2 subsystem and
the support for i386, x86_64, various mips, and powerpc.  The perfmon2
subsystem also works on all Itanium processors, yet the Itanium patches are
not posted on LKML due to the 100k message. They can be provided separately.
The powerpc (Power5) support is still preliminary.

The patches are relative to 2.6.22-rc3


I have already posted on the list about this subsystem. The code has already
been reviewed last year and lots of changes were made. I am resubmitting today
for a final review before perfmon2 gets merged with mainline kernel.

The patches are split up for easier reading. The split is by functionality
for the common code. The per-architecture code is split between modified
and new files. For each group of patches (separate message), a short description
of what they do is provided.

This codebase represents the work of many people beyond just me and I'd
like to thank them publicly for their valuable contributions to this project.

Thanks.

--
-Stephane
