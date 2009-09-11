Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbZIKD3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbZIKD3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 23:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbZIKD3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 23:29:41 -0400
Received: from mail.perches.com ([173.55.12.10]:1087 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbZIKD3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 23:29:40 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/3] kernel.h: move logging functions to separate file
Date: Thu, 10 Sep 2009 20:29:39 -0700
Message-Id: <cover.1252639195.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel.h has gotten cluttered.
Unclutter it and make it kernel style compatible.

Joe Perches (3):
  include/linux/logging.h: Separate logging functions out of kernel.h
  include/linux/logging.h: Reduce data usage of printk_once
  include/linux/kernel.h: neaten and group functions and definitions

 include/linux/kernel.h  |  754 ++++++++++++++++-------------------------------
 include/linux/logging.h |  313 ++++++++++++++++++++
 2 files changed, 573 insertions(+), 494 deletions(-)
 create mode 100644 include/linux/logging.h

