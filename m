Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbYHCDAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbYHCDAd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 23:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbYHCDAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 23:00:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:17221 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbYHCDAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 23:00:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VTta/xaUGOqSfJa1lz/QS2qiP6xh49XXuNccUFcsdSXMtBasNz7tHC8OC2c48BZUWO
         3YMmPBgji09MvCrm8sj26PiXKwYgRehcpamSwEaS5SuTDzgIHUv2SXOdrkaFYJCEeJKX
         zBrU9nfJVYo2rIfyui7sFsp/NG+pUL1J4VQMw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 00/25] dyn_array and nr_irqs support v3
Date: Sat,  2 Aug 2008 19:59:00 -0700
Message-Id: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, Andrew,

Please check dyn_array support for x86
v3: split changing to nr_irqs to small patches
    fix checkpatch error
    reorder the patch sequence to make dyn_array support go at first
	so could use that with arrays other than NR_IRQS

01: should get into 2.6.27 for bug 11201
02: should get into tip
	remove two unused files
03-06: should get into tip or -mm
	 for generic dyn_array support for x86
21: should get into serial tree?
others: are examples to use dyn_array with nr_irqs...

Thanks

Yinghai Lu

