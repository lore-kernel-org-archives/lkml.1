Return-Path: <linux-kernel-owner+w=401wt.eu-S1760727AbYEMQxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727AbYEMQxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 12:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759487AbYEMQxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 12:53:00 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47253 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759238AbYEMQw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 12:52:58 -0400
From: Sebastian Siewior <bigeasy@linutronix.de>
To: Ingo Molnar <mingo@redhat.com>
Cc: Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: [RFC / PATCH] ftrace support on m68knommu
Date: Tue, 13 May 2008 18:52:42 +0200
Message-Id: <1210697565-3106-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo, Greg,

This patch series includes ftrace support on m68knommu and is against
ftrace-devel. 

Ingo: irq flags aren't conditional so I guess this is one of the things
that an arch has to implement (patch #2). In that case you can dump the
status as well couldn't you (patch #3)? I'm not sure but it is possible
that I mixed up the IRQs OFF & ON thing :)

These patches were function tested and compile-only-tested after porting
to ftrace-devel.

Sebastian
