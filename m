Return-Path: <linux-kernel-owner+w=401wt.eu-S965396AbXCOFXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965396AbXCOFXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 01:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965349AbXCOFXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:23:07 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:45287 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965365AbXCOFR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:17:29 -0400
Message-Id: <20070315051337.488091591@goodmis.org>
User-Agent: quilt/0.45-1
Date: Thu, 15 Mar 2007 01:13:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH take3 00/20] Make common x86 arch area for i386 and x86_64 - Take 3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Once again here's an attempt to put the shared files of x86_64 and i386
into a separate directory.

This time, I took the pains to make sure that each patch in this
series compiles after it is applied.  I did this on both x86_64 as well
as i386, with the affected files config options turned on.

I still stayed away from the pci shared code.

This time I moved the speedstep-lib.h into include/asm-x86. Although all
references to this files now needs to explicitly state
 #include <asm-x86/speedstep-lib.h>
But this will also create a doorway for other shared headers to go
into.

And yes the long term goal is to perhaps make a single arch that can
handle both the i386 modern CPUs as well as the x86_64 code. And then
phase out the x86_64, keeping the current i386 for legacy hardware.

Used git-diff -M for the diffs, so the renames are explicitly stated
as such, but no delete/create diff is made (so patch and quilt will
not apply theses).

Comments and flames welcome.

-- Steve

