Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbXJWMJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbXJWMJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 08:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbXJWMJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 08:09:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbXJWMJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 08:09:09 -0400
Message-Id: <20071023120357.782284000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 23 Oct 2007 14:03:57 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Daniel Walker <dwalker@mvista.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: [RFC/PATCH 0/5] rt: workqueue PI support -v2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Still not more than boot tested,...

Oleg, do you have workqueue test modules?

Changes since -v1:
 - proper plist_head_splice() implementation
 - removed the plist_add(, .tail) thing, using prio -1 instead.

(patch against v2.6.23-rt1)

--

