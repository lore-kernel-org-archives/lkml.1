Return-Path: <linux-kernel-owner+w=401wt.eu-S1759191AbZEFMr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191AbZEFMr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbZEFMrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:47:47 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:46545 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbZEFMrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:47:46 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KJ83JA-04-ZDD-01
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [PATCH 0/2] oprofile: introduce module parameter oprofile.cpu_type
Date: Wed, 6 May 2009 14:39:12 +0200
Message-ID: <1241613554-31539-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
X-OriginalArrivalTime: 06 May 2009 12:47:34.0971 (UTC) FILETIME=[D430E0B0:01C9CE48]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current userland does not yet fully support all cpu types
implemented in the kernel. With the module parameter oprofile.cpu_type
a certain cpu type can be reported to the oprofile userland and thus
makes the kernel usable with current distros.

The event table may not match fully, so care must be taken when using
this parameter.

See also this description:

 oprofile.cpu_type=      Force an oprofile cpu type
                 This might be useful if you have an older oprofile
                 userland or if you want common events.
                 Format: { archperfmon | core_2 }
                 archperfmon: [X86] Force use of architectural
                         perfmon on Intel CPUs instead of the
                         CPU specific event set.
                 core_2: [X86] On Intel systems: report core_2 CPU.

Together with Andi's patches the patch set is also in this tree:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git fixes

The fixes are intended for v2.6.30.

Andi, please let me now if this works for you and if things can go
upstream this way.

-Robert



