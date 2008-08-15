Return-Path: <linux-kernel-owner+w=401wt.eu-S1761195AbYHOTdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761195AbYHOTdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 15:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758135AbYHOTdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 15:33:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55044 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461AbYHOTdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 15:33:41 -0400
Date: Fri, 15 Aug 2008 21:33:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@osdl.org, venki.pallipadi@intel.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Please pull more ACPI/cpuidle updates
Message-ID: <20080815193338.GA3594@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, 

please pull more ACPI updates. This mainly includes the cpuidle 
latency updates Venki did some time ago for your system (due to some SNAFU
they didn't get included earlier) and also a fix for a ioremap
PAT regression exposed by ACPI.

-Andi

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-acpi-2.6 release-2.6.27

Andi Kleen (3):
      x86: Fix ioremap off by one BUG
      Merge branch 'ioremap' into release-2.6.27
      Merge branch 'cpuidle' into release-2.6.27

venkatesh.pallipadi@intel.com (3):
      cpuidle: Do not use poll_idle unless user asks for it
      cpuidle: Menu governor fix wrong usage of measured_us
      cpuidle: Make ladder governor honor latency requirements fully

 arch/x86/mm/ioremap.c              |    2 +-
 drivers/cpuidle/governors/ladder.c |   26 ++++++++++++++++++---
 drivers/cpuidle/governors/menu.c   |   42 ++++++++++++++++++++++++------------
 3 files changed, 51 insertions(+), 19 deletions(-)
