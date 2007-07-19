Return-Path: <linux-kernel-owner+w=401wt.eu-S933439AbXGSHMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbXGSHMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 03:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757408AbXGSHMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 03:12:10 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41741 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757391AbXGSHMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 03:12:08 -0400
Date: Thu, 19 Jul 2007 00:12:06 -0700
From: sukadev@us.ibm.com
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: Pavel Emelianov <xemul@openvz.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Containers <containers@lists.osdl.org>
Subject: [PATCH 0/5][V2] Misc helper patches for pid namespaces
Message-ID: <20070719071206.GE10195@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some helper patches to support multiple pid namespaces. These
were posted earlier on Containers@ mailing list. 

	[PATCH 1/5] Define and use task_active_pid_ns() wrapper
	[PATCH 2/5] Rename child_reaper() function.
	[PATCH 3/5] Use task_pid() to find leader's pid
	[PATCH 4/5] Define is_global_init() and is_container_init().
	[PATCH 5/5] Move alloc_pid() to copy_process()

Changelog:

	- Addressed Oleg Nesterov's comments on [V1] of this patchset.
