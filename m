Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbXDYXGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbXDYXGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbXDYXGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:06:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45078 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511AbXDYXGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:06:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: 2.6.21-rc7-mm1: BUG_ON in kthread_bind during _cpu_down
Date: Thu, 26 Apr 2007 01:10:21 +0200
User-Agent: KMail/1.9.5
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704260110.22224.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The BUG_ON in khthread_bind (line 165 in kthread.c) triggers for me during
attempted suspend to disk, when disable_nonboot_cpus() calls _cpu_down()
(on x86_64).

This didn't happen with 2.6.21-rc6-mm1.

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
