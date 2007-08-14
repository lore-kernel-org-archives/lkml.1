Return-Path: <linux-kernel-owner+w=401wt.eu-S933879AbXHNW45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933879AbXHNW45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757547AbXHNWyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:54:25 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:43206 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935849AbXHNWyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:54:22 -0400
Message-Id: <20070814223845.518697567@breakpoint.cc>
User-Agent: quilt/0.46-1
Date: Wed, 15 Aug 2007 00:38:45 +0200
From: Sebastian Siewior <sebastian@breakpoint.cc>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@suse.de>
Subject: [patch 0/2] use asm() for atomic_{read|set}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I converted i386+x86-64. Compiled, booted and played for a while. The
description of both patches contains the file size of four kernel builds:
- "normal" is 28e8351ac22de25034e048c680014ad824323c65 as it
- "inline asm" is with this patch
- "inline volatile" is *(volatile int *)&(v)->counter as a static inline
  function
- "volatile" is *(volatile int *)&(v)->counter as a #define macro

I hope I don't encourage anyone to use macros over inline functions.

Sebastian
-- 

