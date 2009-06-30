Return-Path: <linux-kernel-owner+w=401wt.eu-S1759480AbZF3ACr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480AbZF3ACr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 20:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755624AbZF3ACS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 20:02:18 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3388 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbZF3ACR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 20:02:17 -0400
From: Joe Perches <joe@perches.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, pierre@ossman.eu, swetland@google.com,
       Andrew Morton <akpm@linux-foundation.org>, San Mehat <san@google.com>
Subject: [PATCH 0/3] msm_sdcc: A few more cleanups
Date: Mon, 29 Jun 2009 17:02:02 -0700
Message-Id: <cover.1246319479.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <20090629214101.GA12043@elf.ucw.cz>
References: <20090629214101.GA12043@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps these are appropriate as well.
Uncompiled, I haven't set up an ARM cross compiler yet.

Signed-off-by: Joe Perches <joe@perches.com>

Joe Perches (3):
  msm_sdcc.c: Convert printk(KERN_<level> to pr_<level>(
  msm_sdcc.c: stylistic cleaning
  msm_sdcc.c: Move overly indented code to separate function

 drivers/mmc/host/msm_sdcc.c |  274 ++++++++++++++++++++-----------------------
 1 files changed, 129 insertions(+), 145 deletions(-)

