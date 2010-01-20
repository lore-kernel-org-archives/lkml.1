Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264Ab0ATU7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab0ATU7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128Ab0ATU7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:59:48 -0500
Received: from www.tglx.de ([62.245.132.106]:43000 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab0ATU7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:59:45 -0500
Message-Id: <20100120171231.922420383@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 20 Jan 2010 20:58:54 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Carsten Emde <cbe@osadl.org>,
       Mathias Weber <mathias.weber.mw1@roche.com>
Subject: [patch 0/3] sched: Make Priority Inheritance POSIX compliant
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current PI implementation violates POSIX scheduling semantics when
a thread is deboosted. The following patch series adresses this.

Thanks and Kudos go to Mathias Weber and Carsten Emde for analysis,
test cases and initial workaround patches.

Thanks,

	tglx

