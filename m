Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbZELXd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbZELXd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758154AbZELX1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:27:48 -0400
Received: from 75-149-38-2-SFBA.hfc.comcastbusiness.net ([75.149.38.2]:36266
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758109AbZELX1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:27:45 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [GIT PULL] xen /proc/mtrr implementation
Date: Tue, 12 May 2009 16:27:38 -0700
Message-Id: <1242170864-13560-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This series of patches makes /proc/mtrr fully functional under Xen.

Thanks,
	J

The following changes since commit ce791368bb4a53d05e78e1588bac0aacde8db84c:
  Jeremy Fitzhardinge (1):
        xen/i386: make sure initial VGA/ISA mappings are not overridden

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git for-ingo/xen/dom0/mtrr

Jeremy Fitzhardinge (1):
      xen: set cpu_callout_mask to make mtrr work

Mark McLoughlin (5):
      xen mtrr: Use specific cpu_has_foo macros instead of generic cpu_has()
      xen mtrr: Use generic_validate_add_page()
      xen mtrr: Implement xen_get_free_region()
      xen mtrr: Add xen_{get,set}_mtrr() implementations
      xen mtrr: Kill some unnecessary includes

 arch/x86/kernel/cpu/mtrr/mtrr.h |    2 +
 arch/x86/kernel/cpu/mtrr/xen.c  |   99 ++++++++++++++++++++++++++++++++-------
 arch/x86/xen/smp.c              |    2 +
 3 files changed, 86 insertions(+), 17 deletions(-)

