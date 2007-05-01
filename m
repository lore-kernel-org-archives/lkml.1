Return-Path: <linux-kernel-owner+w=401wt.eu-S1766873AbXEBUC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766873AbXEBUC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766884AbXEBUC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:02:58 -0400
Received: from mga05.intel.com ([192.55.52.89]:51458 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766873AbXEBUC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:02:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,482,1170662400"; 
   d="scan'208";a="240876164"
Message-Id: <20070501185945.237601000@em64tdvp.jf.intel.com>
Date: Tue, 01 May 2007 11:59:45 -0700
From: Chandramouli Narayanan <mouli@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, akpm@linux-foundation.org
Subject: [PATCH 2.6.21 0/3] x86_64: EFI64 support 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--
Following sets of patches add EFI support to x86_64 architecture.
The patches have been tested against 2.6.21 kernel on Intel platforms
with EFI1.10 and UEFI2.0 firmware. The patch files document
implementation and note issues from testing.

Although the tools below are _not_ needed for building the kernel,
the needed bootloader support and associated tools for x86_64 platforms
with EFI firmware and specifications are listed below.

1. UEFI specification:  http://www.uefi.org

2. Booting EFI64 enabled kernel requires boot loader support.
Patches to elilo and gnu-efi library with x86_64 support and documentation
have been submitted to respective project maintainers.
	elilo: http://sourceforge.net/projects/elilo
	gnu-efi library: Nigel Croxon at HP is the current maintainer

3. The tool to convert ELF to PE-COFF image:
	binutils-2.17.50.0.14 supports Intel64 EFI.
	see http://www.kernel.org/pub/linux/devel/binutils/

4. x86_64 platform with EFI/UEFI firmware.

Greatly appreciate your comments on the patches and feedback 
from testing,

thanks,
Chandramouli Narayanan <mouli@linux.intel.com>
