Return-Path: <linux-kernel-owner+w=401wt.eu-S1752153AbYE2NCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbYE2NCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYE2NBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:01:05 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:64625 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbYE2NBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:01:00 -0400
Message-Id: <20080529125501.196123527@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 14:55:01 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 00/11] s390 bug fixes for 2.6.26-rc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
another batch of s390 patches for 2.6.26, all of them bug fixes.

The shortlog:

Christian Borntraeger (1):
      [S390] s390 types: make dma_addr_t 64 bit capable

Gerald Schaefer (1):
      [S390] appldata: prevent cpu hotplug when walking cpu_online_map.

Hans-Joachim Picht (1):
      [S390] fix sparsemem related compile error with allnoconfig on s390

Heiko Carstens (3):
      [S390] Fix section mismatch warnings.
      [S390] showmem: Only walk spanned pages.
      [S390] sclp_vt220: fix scheduling while atomic bug.

Martin Schwidefsky (3):
      [S390] 3270: fix race with stack local wait_queue_head_t.
      [S390] tape: fix race with stack local wait_queue_head_t.
      [S390] disassembler: fix idte instruction format.

Michael Holzheu (1):
      [S390] tape: Fix race condition in tape block device driver

Stefan Haberland (1):
      [S390] dasd: use a generic wait_queue for sleep_on

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

