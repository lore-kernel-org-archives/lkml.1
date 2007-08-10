Return-Path: <linux-kernel-owner+w=401wt.eu-S938078AbXHJOO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938078AbXHJOO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 10:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764212AbXHJOOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 10:14:11 -0400
Received: from nds154-200.nds.lab.novell.com ([151.155.154.200]:16735 "EHLO
	lsg.lab.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762958AbXHJOOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 10:14:09 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/2] RT: Enhance PREEMPT_TRACE with deeper stacks
To: mingo@elte.hu
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       ghaskins@novell.com
Date: Fri, 10 Aug 2007 08:14:08 -0600
Message-ID: <20070810140745.12966.8464.stgit@lsg>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This series changes the PREEMPT-TRACE behavior for reporting critical
sections.  The previous code reported 2 frames per section.  The new code uses
the save_stack_trace facility to save an arbitrary number of frames (currently
set to 5 via a #define)

For what its worth, these patches assisted me with debugging some issues in
-rt.  The second patch is really a workaround for where X86_64 frame-pointers
apparently are not working under certain circumstances.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
