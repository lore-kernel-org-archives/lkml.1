Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbZKMTyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbZKMTyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757001AbZKMTyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:54:46 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58030 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756927AbZKMTyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:54:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HIVu4B81EivdSbnfOemZf6kGiGngF/3FkunsWZ/M9J3dUbNO6yafKDW+3aROXyr88v
         nAsH1UhX5G8YD9tj0gepLoUg793x0CRuUx3YqXLhRwRJDnJ+iTYjVKKdTUeGhLZF/2Qo
         35YBVWFTemKkz7wuD0OwdXWjFYkW0VqV2b+KA=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] x86: Merge kernel_thread() 
Date: Fri, 13 Nov 2009 14:54:54 -0500
Message-Id: <1258142098-3832-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series merges 32/64-bit implementations of kernel_thread,
and cleans up related code.

 arch/x86/kernel/entry_32.S       |    8 +----
 arch/x86/kernel/entry_64.S       |   49 ++-----------------------------------
 arch/x86/kernel/process.c        |   30 +++++++++++++++++++++++
 arch/x86/kernel/process_32.c     |   33 -------------------------
 arch/x86/kernel/process_64.c     |    7 ++---
 arch/x86/kernel/x8664_ksyms_64.c |    2 -
 6 files changed, 38 insertions(+), 91 deletions(-)

--
Brian Gerst
