Return-Path: <linux-kernel-owner+w=401wt.eu-S1761736AbZLKEvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761736AbZLKEvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759506AbZLKEvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:51:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34001 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578AbZLKEue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:50:34 -0500
X-Authority-Analysis: v=1.0 c=1 a=-eflNw0LABcA:10 a=VwQbUJbxAAAA:8 a=3lA4TRqrfX_84kPE_IEA:9 a=1CWKp3Epye5-9FIwM42NC8n78ygA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20091211045003.107725797@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Dec 2009 23:50:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] [GIT PULL][v2.6.33] ring-buffer: resizing issues
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Steven Rostedt (2):
      ring-buffer: Use sync sched protection on ring buffer resizing
      ring-buffer: Move resize integrity check under reader lock

----
 kernel/trace/ring_buffer.c |   29 +++++++++++------------------
 1 files changed, 11 insertions(+), 18 deletions(-)
