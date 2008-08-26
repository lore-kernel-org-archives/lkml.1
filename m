Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbYHZCJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbYHZCJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 22:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbYHZCJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 22:09:27 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:20602 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbYHZCJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 22:09:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=DItPEmhOshwW1nYREqv8582zsAHk5QirgKTy9SeJOGckUcOUjJ1wFMMXYQd/ThV4p1
         2xc/MK/+XVoWpTLA0owjrfr5UwB81hHkHKXX/6p9yXBIp3E5L9Tp0MIRleI+8YWRQPDR
         9hVkxAYvNJ7/HDcm06to6n7wmORb9XZ9m5RaA=
Message-ID: <48f7fe350808251909g26207e7agdda6408c0b46a1ed@mail.gmail.com>
Date: Mon, 25 Aug 2008 22:09:25 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: [-mmotm] BUG: scheduling while atomic: swapper
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUG: scheduling while atomic: swapper/1/0x00000002
Modules linked in:
Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc4-zenmmotm1 #4
 [<c057a0c7>] schedule+0x287/0x6d0
 [<c03672e6>] vsnprintf+0x3a6/0x6c0
 [<c057a92d>] schedule_timeout+0x7d/0xb0
 [<c021e0c8>] __wake_up+0x38/0x50
 [<c057a74a>] wait_for_common+0x8a/0x130
 [<c0220ab0>] default_wake_function+0x0/0x10
 [<c0237743>] call_usermodehelper_exec+0xc3/0xf0
 [<c0362ede>] kobject_uevent_env+0x37e/0x3a0
 [<c03d5921>] device_add+0x551/0x630
 [<c03d5ac3>] device_create_vargs+0xb3/0xd0
 [<c06ccc47>] microcode_intel_module_init+0x0/0x39
 [<c03d5b0b>] device_create+0x2b/0x30
 [<c0385f2e>] misc_register+0xbe/0x170
 [<c02137d1>] microcode_init+0x21/0xf0
 [<c0201336>] do_one_initcall+0x26/0x170
 [<c021e0c8>] __wake_up+0x38/0x50
 [<c0237c98>] insert_work+0x48/0x50
 [<c02380a5>] __queue_work+0x25/0x40
 [<c023812a>] queue_work_on+0x3a/0x50
 [<c06c29bf>] kernel_init+0x170/0x251
 [<c06c284f>] kernel_init+0x0/0x251
 [<c0204157>] kernel_thread_helper+0x7/0x10
 =======================
