Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbZJMBeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbZJMBeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 21:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758692AbZJMBeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 21:34:23 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:41908 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758685AbZJMBeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 21:34:22 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v3 0/7] m68knommu: Clean up linker script using new linker script macros.
Date: Mon, 12 Oct 2009 21:30:06 -0400
Message-Id: <1255397413-4862-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <4AD3BFD8.90408@snapgear.com>
References: <4AD3BFD8.90408@snapgear.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009, Greg Ungerer wrote:
> Tim Abbott wrote:
>> I don't any good ideas for what in patch is likely to be
>> responsible.  Would it be helpful to debug if I split this into ~5
>> very small patches so that we can find out what part of the patch
>> is responsible?
> Yes, that will make it quick and easy for me.

OK, below's a new patch series that is the same as the previous one
but in 7-patch format.

	-Tim Abbott

Tim Abbott (7):
  m68knommu: Don't hardcode the value of PAGE_SIZE in the linker
    script.
  m68knommu: Make THREAD_SIZE available to assembly files.
  m68knommu: Use INIT_TASK_DATA and CACHELINE_ALIGNED_DATA.
  m68knommu: Use more macros inside the .init section.
  m68knommu: Move __init_begin out of the .init section.
  m68knommu: Move __init_end out of the .init section.
  m68knommu: Split the .init section into INIT_TEXT_SECTION and
    INIT_DATA_SECTION.

 arch/m68k/include/asm/thread_info_no.h |    4 +-
 arch/m68knommu/kernel/vmlinux.lds.S    |   41 ++++++++-----------------------
 2 files changed, 13 insertions(+), 32 deletions(-)

