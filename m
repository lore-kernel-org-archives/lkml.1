Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbXGRHc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbXGRHc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 03:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbXGRHcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 03:32:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52600 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbXGRHcE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 03:32:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 0/5] Freezer update
Date: Wed, 18 Jul 2007 09:29:30 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707180929.31511.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patches in these series update the freezer to eliminate some existing
shortcomings, so please consider them as 2.6.23 material.

The patches do the following:
* update the freezer documentation to describe, previously omitted, important
  reason for freezing tasks (ie. memory shrinking)
* remove sys_sync() from the freezer and make the suspend/hibernation code
  invoke it explicitly
* prevent new tasks from inheriting TIF_FREEZE set from the parents
* introduce freezer-firendly wrappers around wait_event_interruptible()
  and wait_event_interruptible_timeout()
* prevent the freezer from sending signals to kernel threads

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

