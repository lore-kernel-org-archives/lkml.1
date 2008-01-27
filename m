Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbYA0Vce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbYA0Vce (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 16:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbYA0VcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 16:32:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58976 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726AbYA0VcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 16:32:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: [Regression] 2.6.24-git3: Major annoyance during suspend/hibernation on x86-64 (bisected)
Date: Sun, 27 Jan 2008 22:29:48 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Steven Rostedt <srostedt@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801272229.48955.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2.6.24-git3 adds a 5 - 10 sec delay to the suspend and hibernation code paths
(probably related to the disabling of nonboot CPUs), which is !@#$%^&*()
annoying.

It's 100% reproducible on my HP nx6325 and bisection idendified the following
commit as the first bad one:

commit 764a9d6fe4b52995c8aba277e3634385699354f4
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Jan 25 21:08:04 2008 +0100

    sched: track highest prio task queued

Greetings,
Rafael
