Return-Path: <linux-kernel-owner+w=401wt.eu-S934583AbXEHQFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934583AbXEHQFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 12:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934331AbXEHQFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 12:05:12 -0400
Received: from main.gmane.org ([80.91.229.2]:45101 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933977AbXEHQFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 12:05:11 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Vladimir Pouzanov <farcaller@gmail.com>
Subject: ACPI Power Down is broken in 2.6.21.1
Date: Tue, 8 May 2007 16:01:14 +0000 (UTC)
Message-ID: <loom.20070508T175303-27@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 91.124.62.29 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070328 Firefox/2.0.0.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have got a problem with Asus F3T notebook and 2.6.21.1 kernel. When I
perform powerdown (with user-space app or alt+sysrq+o) I get "Power Down."
message, but the notebook doesn't turn off. Everything is ok on 2.6.20.

There seem to be no changes in acpi/sleep/poweroff.c so I don't know where
should I start looking for a bug.

F3T is based on Thrion64 X2 CPU (I'm running it in x86 mode with SMP and
PREEMPT).

Sincerely,
Vladimir "Farcaller" Pouzanov
http://hackndev.com

