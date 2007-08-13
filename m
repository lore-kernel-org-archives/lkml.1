Return-Path: <linux-kernel-owner+w=401wt.eu-S945547AbXHMMs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945547AbXHMMs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966020AbXHMHah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 03:30:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:12288 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966883AbXHMHaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 03:30:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,253,1183359600"; 
   d="scan'208";a="278034039"
Subject: [PATCH 0/3] x86_64 EFI runtime service support
From: "Huang, Ying" <ying.huang@intel.com>
To: Andi Kleen <ak@suse.de>, akpm@linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Aug 2007 15:30:19 +0800
Message-Id: <1186990219.22431.37.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 13 Aug 2007 07:29:56.0850 (UTC) FILETIME=[BF986520:01C7DD7B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following sets of patches add EFI/UEFI (Unified Extensible Firmware
Interface) runtime services support to x86_64 architecture. The
patches have been tested against 2.6.23-rc2 kernel on Intel platforms
with EFI1.10 and UEFI2.0 firmware. This patch set is based on previous
x86_64 EFI boot support patch set.

Known issues:

- Virtual mode support is still retained in this patch. The fixmap is
  used to map IO region used by EFI runtime service. This makes kexec
  workable under EFI.

- The variable efi_enabled is used throughout across architectures if
 CONFIG_EFI option is enabled. The i386 code also uses this variable.
 This is something that can be revisited with code consolidation
 across architectures. But, the EFI time runtime service is changed to
 use function pointers, and the EFI reset_system runtime service is
 changed to use reboot_type variable.

Looking forward to your comments,

Best Regards,
Huang Ying
