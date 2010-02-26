Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965454Ab0BZRPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:15:54 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:50527 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965152Ab0BZRPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:15:52 -0500
X-IronPort-AV: E=Sophos;i="4.49,547,1262581200"; 
   d="scan'208";a="85874801"
Subject: [GIT 0/3] x86: remove kmap_atomic_pte paravirt op
From: Ian Campbell <Ian.Campbell@citrix.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Alok Kataria <akataria@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Fri, 26 Feb 2010 17:15:47 +0000
Message-ID: <1267204547.11737.12659.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c1fd1b43831fa20c91cdd461342af8edf2e87c2f:
  Pekka Enberg (1):
        x86, mm: Unify kernel_physical_mapping_init() API

are available in the git repository at:

  git://xenbits.xensource.com/people/ianc/linux-2.6.git for-x86/mm

Ian Campbell (3):
      xen: disable highmem PTE allocation even when CONFIG_HIGHPTE=y
      vmi: disable highmem PTE allocation even when CONFIG_HIGHPTE=y
      x86: remove kmap_atomic_pte paravirt op.

 arch/x86/include/asm/highmem.h        |    4 ---
 arch/x86/include/asm/paravirt.h       |    9 --------
 arch/x86/include/asm/paravirt_types.h |    4 ---
 arch/x86/include/asm/pgtable_32.h     |    4 +-
 arch/x86/kernel/paravirt.c            |    4 ---
 arch/x86/kernel/vmi_32.c              |   35 ++++++--------------------------
 arch/x86/xen/enlighten.c              |    7 ++++++
 arch/x86/xen/mmu.c                    |   21 -------------------
 8 files changed, 16 insertions(+), 72 deletions(-)


