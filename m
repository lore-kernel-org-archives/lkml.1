Return-Path: <linux-kernel-owner+w=401wt.eu-S1030825AbXDVUBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030825AbXDVUBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 16:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030826AbXDVUBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 16:01:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57638 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030825AbXDVUBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 16:01:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH -mm 0/3] Separate freezer flags
Date: Sun, 22 Apr 2007 21:28:48 +0200
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, ego@in.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, paulmck@us.ibm.com, pavel@ucw.cz
References: <20070419120131.GB13435@in.ibm.com> <20070420103052.686f3c71.akpm@linux-foundation.org> <20070420183118.GA695@elte.hu>
In-Reply-To: <20070420183118.GA695@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704222128.49419.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following three patches are related to the separation of the freezer flags
from process/threadinfo flags.

The first patch separates the freezer from the PM code, because it's no longer
a PM-specific piece of code.  This also makes the second patch look better.

The second patch introduces the freezer_flags field of task_struct, present
only if the freezer is compiled in.  All of the freezer-related flags per-task
flags are moved to this field and auxiliary functions for operating them are
defined in freezer.h .  This overlaps with the Gautham's work to some extent,
but I think it's better to introduce these changes independently of the CPU
hotplug code.

The third patch is a bonus. ;-)

Greetings,
Rafael

