Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbZCLMIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbZCLMIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755701AbZCLMIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:08:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:57616 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbZCLMIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:08:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=cb4rmoqOBMqnazrH7Ne8T3n46sH45Dy8tid1ZBmbAImv9GUdzRwwGlb8o89pLXLn6t
         7PwIpQ5/PoVob9XI3tMK5H+lINm3rD4pynKqmYyV/jL5CfQHtRO/eLnBgvvfeb7DtQTT
         5v4TNZnouFr3JXrmD3+zXuCy0y3fXvF8kGA2k=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, lethal@linux-sh.org,
       tglx@linutronix.de, mingo@elte.hu, akpm@linux-foundation.org
Date: Thu, 12 Mar 2009 21:05:34 +0900
Message-Id: <20090312120534.2926.78511.sendpatchset@rx1.opensource.se>
Subject: [PATCH 00/03] Free setup_irq() interrupt V3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free setup_irq() interrupt V3

These patches improve the early interrupt functions to support
both registering and unregistering. While at it the functions
are exported so they can be used both early from compiled-in
driver and as a regular module.

[PATCH 01/03] Add remove_irq() for freeing of setup_irq() irqs
[PATCH 02/03] Match remove_irq() args with setup_irq()
[PATCH 03/03] Export remove_irq() and setup_irq() symbols

The first patch does exactly what Ingo and Thomas suggests as
feedback to V2. The second and third are my more or less useful
improvements. =) Feel free to just pick up the first one.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Applies to tip.git.

 include/linux/irq.h |    3 +-
 kernel/irq/manage.c |   67 ++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 47 insertions(+), 23 deletions(-)
