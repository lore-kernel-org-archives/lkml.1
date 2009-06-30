Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbZF3PhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbZF3PhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 11:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbZF3PhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 11:37:09 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:61985 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbZF3PhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 11:37:08 -0400
Subject: [GIT PULL] Kmemleak fixes
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 30 Jun 2009 16:37:01 +0100
Message-Id: <1246376222.22578.131.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jun 2009 15:37:02.0835 (UTC) FILETIME=[9D6E0C30:01C9F998]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please merge the kmemleak branch detailed below? It contains
fixes aimed at reducing the false positives and the syslog backtraces.

Thanks.

The following changes since commit 28d0325ce6e0a52f53d8af687e6427fee59004d3:
  Linus Torvalds (1):
        Linux 2.6.31-rc1

are available in the git repository at:

  git://linux-arm.org/linux-2.6.git kmemleak

Catalin Marinas (8):
      kmemleak: Allow the early log buffer to be configurable.
      kmemleak: Enable task stacks scanning by default
      kmemleak: Simplify the reports logged by the scanning thread
      kmemleak: Do not trigger a scan when reading the debug/kmemleak file
      kmemleak: Slightly change the policy on newly allocated objects
      kmemleak: Do not report new leaked objects if the scanning was stopped
      kmemleak: Do not warn if an unknown object is freed
      kmemleak: Inform kmemleak about pid_hash

 Documentation/kmemleak.txt |   23 ++++--
 kernel/pid.c               |    7 ++
 lib/Kconfig.debug          |   12 +++
 mm/kmemleak.c              |  166 ++++++++++++++++++-------------------------
 4 files changed, 105 insertions(+), 103 deletions(-)

-- 
Catalin

