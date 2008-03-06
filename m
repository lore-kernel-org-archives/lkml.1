Return-Path: <linux-kernel-owner+w=401wt.eu-S932116AbYCFKro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116AbYCFKro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 05:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756553AbYCFKrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:47:35 -0500
Received: from www.tglx.de ([62.245.132.106]:37900 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986AbYCFKre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:47:34 -0500
Date: Thu, 6 Mar 2008 11:47:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: David Miller <davem@davemloft.net>
Subject: Treason uncloaked spams syslog with latest git
Message-ID: <alpine.LFD.1.00.0803061140380.3099@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since I updated one of my compile boxen to latest git I get the syslog
flooded with:

TCP: Treason uncloaked! Peer 192.168.0.1:10245/56637 shrinks window 2748077551:2748080447. Repaired.
TCP: Treason uncloaked! Peer 192.168.0.68:10245/39915 shrinks window 2890195332:2890201124. Repaired.
TCP: Treason uncloaked! Peer 192.168.0.65:10245/46058 shrinks window 2880740873:2880745217. Repaired.

This happens _always_ when I compile kernels with distcc or icecc. All
systems involved run Linux with kernels >= 2.6.23 and are on the same
network; no routers, firewalls or other fancy stuff.

Any idea what's going on here ?

Thanks,

	tglx
