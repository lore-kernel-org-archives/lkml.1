Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbZFDBrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbZFDBrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 21:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbZFDBrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 21:47:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47986 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbZFDBrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 21:47:11 -0400
Date: Wed, 3 Jun 2009 21:46:00 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jdike@addtoit.com, rusty@rustcorp.com.au, hch@infradead.org,
       Amerigo Wang <amwang@redhat.com>, akpm@linux-foundation.org,
       mingo@elte.hu
Message-Id: <20090604014813.6332.18486.sendpatchset@localhost.localdomain>
Subject: [Patch 0/5][V2] module: merge module_32.c and module_64.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch set aims to merge module_32.c and module_64.c into
module.c. And plus some other related fixes.

Please apply in order.

I have tested this patch set on x86_64, and uml over x86_64,
and compile tested on i386. It looks fine.

V2:
Trimming exception tables correctly.
Unify module_alloc() for x86.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>

