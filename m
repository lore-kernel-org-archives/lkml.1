Return-Path: <linux-kernel-owner+w=401wt.eu-S1753332AbYKUDPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbYKUDPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 22:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYKUDPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 22:15:17 -0500
Received: from mail.windriver.com ([147.11.1.11]:50989 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbYKUDPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 22:15:16 -0500
From: Liming Wang <liming.wang@windriver.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] function tracing: fix wrong position computing of stack_trace
Date: Fri, 21 Nov 2008 11:00:17 +0800
Message-Id: <1227236418-6023-1-git-send-email-liming.wang@windriver.com>
X-Mailer: git-send-email 1.6.0.3
X-OriginalArrivalTime: 21 Nov 2008 03:15:00.0686 (UTC) FILETIME=[56DE7EE0:01C94B87]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven and Ingo,

Before I have submitted a patch to fix output of available_filter_functions,
later I checked other places that use seq_operations, I found stack_trace
also has this potential problem.

This fix use a more sane method to implement seq_operations. And this avoids
checking return value of seq_printf. If you think this implementation is OK,
I think others can be convert to this cleaner way, which will make future 
usage of seq_operations less errors.

walimis

