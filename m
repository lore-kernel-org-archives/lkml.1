Return-Path: <linux-kernel-owner+w=401wt.eu-S1751308AbZIHOkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308AbZIHOkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 10:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbZIHOko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 10:40:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbZIHOko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 10:40:44 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH -tip 0/1] posix-cpu-timers: fix CPUCLOCK_{PROF,VIRT} periodic tics precision -v1
Date: Tue,  8 Sep 2009 16:40:07 +0200
Message-Id: <1252420808-4273-1-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1250001100-3936-1-git-send-email-sgruszka@redhat.com>
References: <1250001100-3936-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reference:
http://lkml.org/lkml/2009/8/11/174

Changelog v0 -> v1:

Fix for PowerPC with CONFIG_VIRT_CPU_ACCOUNTING. Due to rounding return
value of cputime_to_jiffies(), calculations of next expiration time
not worked as I expected. I removed any conversions and do direct
calculations on cputime values treat them as unsigned long long.

Cheers
Stanislaw
