Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbZLIKPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbZLIKPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 05:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZLIKPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 05:15:05 -0500
Received: from www.tglx.de ([62.245.132.106]:39990 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbZLIKPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 05:15:05 -0500
Message-Id: <20091209100540.511353305@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 09 Dec 2009 10:14:54 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 0/4] sched: Replace read_lock(&tasklist_lock) with RCU - the
	easy part
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First batch of patches which replace read_lock(&tasklist_lock) with
RCU.

Thanks,

	tglx

