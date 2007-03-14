Return-Path: <linux-kernel-owner+w=401wt.eu-S933836AbXCNFNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836AbXCNFNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 01:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933840AbXCNFMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 01:12:46 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:48649 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933836AbXCNFMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 01:12:05 -0400
Message-Id: <20070314051048.576711999@goodmis.org>
References: <20070314050819.536207642@goodmis.org>
User-Agent: quilt/0.45-1
Date: Wed, 14 Mar 2007 01:08:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 06/18] mv kernel/cpu/cpufreq/speedstep-lib.h
Content-Disposition: inline; filename=cpu-freq-mv-speedstep-lib-h.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OK, this one is a little different.

Move arch/i386/kernel/cpu/cpufreq/speedstep-lib.h to include/asm-i386.h

This file is used by files in arch/i386/kernel/cpu/cpufreq that are not moved.
So we move it into a more global area, to keep the includes from going a bit
crazy.

Note, the moved files that include this file will have the change to
locate it. So it's not just a straight copy.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@muc.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>

diff --git a/arch/i386/kernel/cpu/cpufreq/speedstep-lib.h b/include/asm-i386/speedstep-lib.h
similarity index 100%
rename from arch/i386/kernel/cpu/cpufreq/speedstep-lib.h
rename to include/asm-i386/speedstep-lib.h

--
