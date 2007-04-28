Return-Path: <linux-kernel-owner@vger.kernel.org>
X-Sieve: CMU Sieve 2.2
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbXD0Pgz (ORCPT <rfc822;rjwysocki@sisk.pl>);
	Fri, 27 Apr 2007 11:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756006AbXD0Pgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:36:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57317 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755874AbXD0Pgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:36:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 0/2] Separate freezer from PM code (take 2)
Date: Sat, 28 Apr 2007 11:35:55 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200704281135.56275.linux-kernel-owner@vger.kernel.org>
X-Length: 1307
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit

Hi,

The first patch in the series separates the tasks freezer from the PM code and
moves it to kernel/freezer.c .  No changes to the moved code are made.

The second one moves all of the freezer-specific per-task flags to a separate
filed of task_struct and defines functions for manipulating them with the help
of set_bit() and friends.

The patches are against 2.6.21-rc7-mm2 with
move-frozen_process-to-kernel-power-processc.patch applied.

Greetings,
Rafael
