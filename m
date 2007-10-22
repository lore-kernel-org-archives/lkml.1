Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbXJVJzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbXJVJzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbXJVJz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:55:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35759 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbXJVJz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:55:27 -0400
Message-Id: <20071022095054.393085000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 22 Oct 2007 11:50:54 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Daniel Walker <dwalker@mvista.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: [RFC/PATCH 0/3] rt: workqueue PI support
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I revived the PI-workqueue effort. I took daniel's plist patch and went about
fixing the only outstanding issue that I could remember, barriers.

This patch compiles and boots on x86_64, not much testing has been done.

--

