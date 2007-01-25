Return-Path: <linux-kernel-owner+w=401wt.eu-S1030274AbXAYQQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030274AbXAYQQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 11:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030273AbXAYQP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 11:15:59 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:46892 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030258AbXAYQP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 11:15:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Christoph Hellwig <hch@infradead.org>, ltt-dev@shafik.org,
       systemtap@sources.redhat.com, Douglas Niehaus <niehaus@eecs.ku.edu>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [PATCH 00/09] atomic.h : standardizing atomic primitives
Date: Thu, 25 Jan 2007 11:15:45 -0500
Message-Id: <11697417541743-git-send-email-mathieu.desnoyers@polymtl.ca>
X-Mailer: git-send-email 1.4.4.3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

atomic.h : standardizing atomic primitives

It mainly adds support for missing 64 bits cmpxchg and 64 bits atomic add
unless. Therefore, principally 64 bits architectures are targeted by these
patches. It also adds the complete list of atomic operations on the atomic_long
type.

These patches apply on 2.6.20-rc5-git4.

Signed-off-by : Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

