Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbYHBAZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbYHBAZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 20:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbYHBAZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 20:25:04 -0400
Received: from c-98-210-159-26.hsd1.ca.comcast.net ([98.210.159.26]:46977 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751847AbYHBAZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 20:25:03 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 8] x86/smp function calls: convert x86 tlb flushes to use
	function calls
Message-Id: <patchbomb.1217636085@localhost>
Date: Fri, 01 Aug 2008 17:14:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here's the more polished series to:

1. use smp_call_function_mask to implement cross-cpu TLB flushes
2. bring tlb_32/64.c closer together, in preparation for
3. unifying tlb.c
4. add multi-queue capability for smp_call_function
5. implement multiple queues on x86
6. make the number of queues more configurable
7. add a kernel parameter to disable multiple queues in case
   it causes problems

Thanks,
	J

