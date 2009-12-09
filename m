Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbZLIOU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbZLIOU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 09:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbZLIOUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 09:20:01 -0500
Received: from www.tglx.de ([62.245.132.106]:34387 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074AbZLIOUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 09:20:00 -0500
Message-Id: <20091209141540.067855785@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 09 Dec 2009 14:19:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 0/3] audit: Fixes and tasklist_lock -> RCU conversion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the following patches result from auditing read_lock(&tasklist_lock)
sites whether they can be converted to RCU.

Thanks,

	tglx

