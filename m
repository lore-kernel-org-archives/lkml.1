Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbYDBSfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbYDBSfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbYDBSfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:35:32 -0400
Received: from 21.sub-75-208-3.myvzw.com ([75.208.3.21]:38399 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754748AbYDBSfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:35:32 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 00 of 24] More Xen updates 
Message-Id: <patchbomb.1207158829@localhost>
Date: Wed, 02 Apr 2008 10:53:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

More patches.  There are three groups:

- some code movements to make common code available to other
  architectures (namely, ia64)
- Xen device driver updates, including a new xen paravirt framebuffer driver,
- The Xen balloon driver (shrink only, so no dependency on memory hotplug yet)
- some "using smp_processor_id while preemptable" warning fixes,
  mostly as a result of the core kernel's tendency to do tlb flushes
  and update init_mm while preemptable,
- other little Xen cleanups

Thanks,
	J


