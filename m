Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbZCRMtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbZCRMtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 08:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755752AbZCRMsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 08:48:53 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:40324 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbZCRMsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 08:48:52 -0400
Message-Id: <20090318124829.637003183@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 18 Mar 2009 13:48:29 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 0/6] s390 bug fixes for 2.6.29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
some of the bug fixes in my feature patch pile for the next merge
window are severe enough to warrent inclusion in 2.6.29.
There are 6 relevant patches:

Gerald Schaefer (1):
      [S390] Dont check for pfn_valid() in uaccess_pt.c

Heiko Carstens (2):
      [S390] topology: define SD_MC_INIT to fix performance regression
      [S390] ftrace/mcount: fix kernel stack backchain

Martin Schwidefsky (3):
      [S390] __div64_31 broken for CONFIG_MARCH_G5
      [S390] make page table walking more robust
      [S390] make page table upgrade work again

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

