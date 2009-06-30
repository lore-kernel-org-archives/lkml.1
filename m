Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbZF3Pbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbZF3Pbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 11:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbZF3Pbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 11:31:41 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4309 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbZF3Pbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 11:31:41 -0400
From: Joe Perches <joe@perches.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, pierre@ossman.eu, swetland@google.com,
       Andrew Morton <akpm@linux-foundation.org>, San Mehat <san@google.com>
Subject: [PATCH V2 0/3] msm_sdcc: cleanups
Date: Tue, 30 Jun 2009 08:31:36 -0700
Message-Id: <cover.1246371533.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <20090630132112.GB28447@elf.ucw.cz>
References: <20090630132112.GB28447@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel.

Here's another slightly redone pass with your compile fixes.

In patch 3/3 I changed the argument list of handle_irq_data
for a bit better localization of variable use.

Joe Perches (3):
  msm_sdcc.c: Convert printk(KERN_<level> to pr_<level>(
  msm_sdcc.c: stylistic cleaning
  msm_sdcc.c: Move overly indented code to separate function

 drivers/mmc/host/msm_sdcc.c |  282 ++++++++++++++++++++----------------------
 1 files changed, 134 insertions(+), 148 deletions(-)

