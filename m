Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbZGCCRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbZGCCRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 22:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757233AbZGCCRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 22:17:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:41765 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863AbZGCCRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:17:34 -0400
Subject: Reminder for feature EXPORT_SYMBOL(kernel_thread) removal date
 August 2006
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 03 Jul 2009 07:31:58 +0530
Message-Id: <1246586518.2530.4.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Christoph,

What:   remove EXPORT_SYMBOL(kernel_thread)
When:   August 2006
Files:  arch/*/kernel/*_ksyms.c
Check:  kernel_thread
Why:    kernel_thread is a low-level implementation detail.  Drivers should
        use the <linux/kthread.h> API instead which shields them from
        implementation details and provides a higherlevel interface that
        prevents bugs and code duplication
Who:    Christoph Hellwig <hch@lst.de>

If you are facing any issue regarding feature removal kindly update the
"Documentation/feature-removal-schedule.txt" like what you are waiting
for.

Thanks,
--
JSR

http://userweb.kernel.org/~jaswinder/

