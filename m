Return-Path: <linux-kernel-owner+w=401wt.eu-S1759971AbZFZONS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759971AbZFZONS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbZFZONG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:13:06 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:61919 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753259AbZFZONG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:13:06 -0400
Subject: [PATCH 0/4] Kmemleak improvements on false positives
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Date: Fri, 26 Jun 2009 15:12:35 +0100
Message-ID: <20090626140847.31504.79381.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.387.geb0c.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2009 14:12:36.0034 (UTC) FILETIME=[27BA9220:01C9F668]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This set of patches are aimed at reducing the amount of false positives
and the verbosity of the kmemleak reports. The task stack scanning is no
enabled by default but this can be disabled at run-time with a risk of
more false positives.

I haven't looked into Sergey's function filtering patch yet.

Thanks for your comments.


Catalin Marinas (4):
      kmemleak: Slightly change the policy on newly allocated objects
      kmemleak: Do not trigger a scan when reading the debug/kmemleak file
      kmemleak: Simplify the reports logged by the scanning thread
      kmemleak: Enable task stacks scanning by default


 Documentation/kmemleak.txt |   19 ++++--
 mm/kmemleak.c              |  144 +++++++++++++++++---------------------------
 2 files changed, 67 insertions(+), 96 deletions(-)

-- 
Catalin
