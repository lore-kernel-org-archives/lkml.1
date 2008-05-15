Return-Path: <linux-kernel-owner+w=401wt.eu-S1759025AbYEONny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025AbYEONny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 09:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbYEONnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 09:43:46 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:56320 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbYEONnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 09:43:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=To:Date:From:Received:Subject:Mime-Version:Message-Id:Content-Transfer-Encoding:Content-Type:X-Abuse:X-Seznam-User:X-QM-Mark;
	b=P8GVTmGhUoV2SghAap/ZRqMbms9uC4lS5lYH+HtT5BV0NHKlCa8yAKNoTBYGrOxiN
	Ar5QmXdC9m0KDL48BR3punWRz2s61dvyZKjyY4BefcAVmME3SKc74hoHZ2xJMZEUHu/
	NHqlCWdM8jIzk8bRdORydiiNePuPd+2TMU2e/+U=
To: =?us-ascii?Q?Linux=20Kernel=20list?= <linux-kernel@vger.kernel.org>
Date: Thu, 15 May 2008 15:37:35 +0200 (CEST)
From: =?us-ascii?Q?Michal=20Simek?= <Monstr@seznam.cz>
Subject: =?us-ascii?Q?PRINTK=5FTIME?=
Mime-Version: 1.0
Message-Id: <5284.8268-13007-901443894-1210858655@seznam.cz>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset="us-ascii"
X-Abuse: abuse@seznam.cz
X-Seznam-User: Monstr@seznam.cz
X-QM-Mark: email-qm1<70912870>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI All,

I had problem with non zero value when I turn on PRINTK_TIME.

Part of log. Zero value is only before sched starting.

[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Self modified code enable
[42949372.960000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8128
[42949372.960000] Kernel command line: console=ttyUL0,115200
[42949372.960000] xlnx,xps-intc-1.00.a #0 at 0x40000000, num_irq=8, edge=0x0

I think I need to set this starting value to zero.
Could you give me a hit where the problem can be?

Thanks,
Michal
