Return-Path: <linux-kernel-owner+w=401wt.eu-S936740AbXHOVEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936740AbXHOVEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 17:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936238AbXHOVEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 17:04:11 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:45163 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758778AbXHOVEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 17:04:09 -0400
Message-Id: <20070815205430.512612422@breakpoint.cc>
User-Agent: quilt/0.46-1
Date: Wed, 15 Aug 2007 22:54:30 +0200
From: Sebastian Siewior <sebastian@breakpoint.cc>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@suse.de>, Chris Snook <csnook@redhat.com>
Subject: [patch 0/2] use asm() for atomic_{read|set} (shot 2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Diff to last post:
- no __*__ functions used.
- no white space fixes.

I converted i386+x86-64 arch. The description of both patches contains the 
file size of four kernel builds:
- "normal" is 28e8351ac22de25034e048c680014ad824323c65 as it
- "inline asm" is with this patch
- "inline volatile" is *(volatile int *)&(v)->counter as a static inline
  function
- "volatile" is *(volatile int *)&(v)->counter as a #define macro

Sebastian
-- 

