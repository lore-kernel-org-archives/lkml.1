Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbYEWNJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbYEWNJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYEWNJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:09:20 -0400
Received: from gw.goop.org ([64.81.55.164]:33884 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbYEWNJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:09:20 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 5] xen: paravirt framebuffer updates
Message-Id: <patchbomb.1211547980@localhost>
Date: Fri, 23 May 2008 14:06:20 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Markus Armbruster <armbru@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This is a series from Markus Armbruster <armbru@redhat.com> which
updates the Xen paravirtal framebuffer driver.  Nothing very exciting.

The only non-Xen code touched by this series is in "xen: Enable
console tty by default in domU if it's not a dummy", which adds a
simple flag to kernel/printk.c to indicate that the preferrered
console was set on the command line, which overrides any heuristics.

Thanks,
	J

