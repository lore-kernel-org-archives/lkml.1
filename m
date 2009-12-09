Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbZLIReP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbZLIReP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZLIReP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:34:15 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:52269 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbZLIReO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:34:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=H9o8rdUV149snTJh1aJaPLxx9j/9njNko6rRNX3g2Al0s0reggcdIm9KYwjLaHOAfF
         5WRLE+JqAdzJraB1SDYI1w1se09iGxYTWI4/O0V8fQWPCm8n9+1KUzhd2qEFYqNuMZWZ
         gFDEoZHFLUhVjrZFVqGu6A/FLzZoU5LURKAjk=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] x86: Merge kernel_thread()
Date: Wed,  9 Dec 2009 12:34:39 -0500
Message-Id: <1260380084-3707-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/5] x86, 64-bit: Move kernel_thread to C
[PATCH 2/5] x86, 64-bit: Use user_mode() to determine new stack pointer in copy_thread()
[PATCH 3/5] x86, 32-bit: Use same regs as 64-bit for kernel_thread_helper
[PATCH 4/5] x86: Sync 32/64-bit kernel_thread
[PATCH 5/5] x86: Merge kernel_thread()

 arch/x86/kernel/entry_32.S       |    8 +----
 arch/x86/kernel/entry_64.S       |   49 ++-----------------------------------
 arch/x86/kernel/process.c        |   35 +++++++++++++++++++++++++++
 arch/x86/kernel/process_32.c     |   33 -------------------------
 arch/x86/kernel/process_64.c     |    7 ++---
 arch/x86/kernel/x8664_ksyms_64.c |    2 -
 6 files changed, 43 insertions(+), 91 deletions(-)

