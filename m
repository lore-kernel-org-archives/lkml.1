Return-Path: <linux-kernel-owner+w=401wt.eu-S1422980AbXBHN1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422980AbXBHN1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 08:27:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423006AbXBHN1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 08:27:04 -0500
Received: from cantor.suse.de ([195.135.220.2]:37962 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422980AbXBHN1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 08:27:03 -0500
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Memory Management <linux-mm@kvack.org>,
       Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Message-Id: <20070208111421.30513.77904.sendpatchset@linux.site>
Subject: [patch 0/3] 2.6.20 fix for PageUptodate memorder problem (try 2)
Date: Thu,  8 Feb 2007 14:26:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Still no independent confirmation as to whether this is a problem or not.
Updated some comments, added diffstats to patches, don't use __SetPageUptodate
as an internal page-flags.h private function.

I would like to eventually get an ack from Hugh regarding the anon memory
and especially swap side of the equation, and a glance from whoever put the
smp_wmb()s into the copy functions (Was it Ben H or Anton maybe?)

Thanks,
Nick

--
SuSE Labs

