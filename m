Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbXJCMdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbXJCMdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 08:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbXJCMdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 08:33:36 -0400
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:27761 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755926AbXJCMdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 08:33:36 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: top displaying 9999% CPU usage
Date: Wed, 3 Oct 2007 14:33:34 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710031433.34504.elendil@planet.nl>
X-OriginalArrivalTime: 03 Oct 2007 12:33:34.0926 (UTC) FILETIME=[9D7B6EE0:01C805B9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I saw top occasionally displaying 9999% CPU usage for a process. The
first few times it was amarokapp, this last time it was kontact.
Both applications were basically idle.
The "cc1" is a kernel compile (rc9 + CFS :-).

I cannot remember seeing this before, but as I also don't run top that
frequently I cannot be sure its a recent regression.

$ uname -a
Linux faramir 2.6.23-rc9 #1 SMP Tue Oct 2 11:16:15 CEST 2007 x86_64 GNU/Linux

top - 14:28:27 up 38 min,  1 user,  load average: 1.12, 0.67, 0.32
Tasks: 128 total,   2 running, 126 sleeping,   0 stopped,   0 zombie
Cpu(s): 32.0%us, 15.7%sy,  0.0%ni, 43.8%id,  8.5%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   2054476k total,   998460k used,  1056016k free,    95284k buffers
Swap:   979924k total,        0k used,   979924k free,   485804k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 5269 fjp       20   0  441m  58m  32m S 9999  2.9   0:16.34 kontact
                                         ^^^^
 8272 fjp       20   0  5952  468  208 S    3  0.0   0:04.62 faked-sysv
 3666 fjp       20   0 25268 2036  884 S    2  0.1   0:03.30 famd
26530 fjp       20   0 20932 6292 1568 R    2  0.3   0:00.06 cc1
 5124 fjp       20   0  210m  26m  19m S    1  1.3   0:09.18 kicker
17012 fjp       20   0 19016 1252  916 R    1  0.1   0:00.34 top
 5159 fjp       20   0  508m  54m  30m S    0  2.7   0:12.67 amarokapp
