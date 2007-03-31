Return-Path: <linux-kernel-owner+w=401wt.eu-S965158AbXCaExp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965158AbXCaExp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 00:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965254AbXCaExp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 00:53:45 -0400
Received: from gw.goop.org ([64.81.55.164]:34189 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965158AbXCaExo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 00:53:44 -0400
Message-Id: <20070331020042.003398870@goop.org>
User-Agent: quilt/0.46-1
Date: Fri, 30 Mar 2007 19:00:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [patch 0/6] i386 gdt and percpu cleanups
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

This is a series of patches based on your latest queue (as of the
other day, at least).

It includes:
 - the most recent patch to compute the appropriate amount of percpu
   space to allocate, using a separate reservation for modules where
   needed.
 - make the percpu sections page-aligned, so that percpu variables can
   be page aligned if needed (which is used by gdt_page)
 - page-align the gdt
 - remove the pda and convert all pda usages into percpu variables
   (percpu variables still use the %fs prefix mechanism the pda used)
 - some improvements to asm-i386/percpu.h to make asm access to percpu
   variables easy
 - define per_cpu_offset in asm-i386/percpu.h, to match asm-generic/

Thanks,
	J

-- 

