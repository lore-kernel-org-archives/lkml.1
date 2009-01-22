Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbZAVRp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbZAVRp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756161AbZAVRnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:43:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:37909 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638AbZAVRnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:43:49 -0500
Message-Id: <20090122173701.674448070@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 22 Jan 2009 18:37:01 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 00/19] lockdep series
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is heavy RFC, only compile tested so far..

Nick ran into the fact that the IRQ state tracker isn't readily
extensible and requires a lot of manual duplication of stuff.

This series tries to address that.

The only function that remains is mark_irqflags() which seems to contain
the actual state interaction, and can thus not easily be unified.

total diffstat (incl Nick's patch)
 10 files changed, 316 insertions(+), 308 deletions(-)

'cleanup' diffstat:
 5 files changed, 231 insertions(+), 446 deletions(-)

-- 

