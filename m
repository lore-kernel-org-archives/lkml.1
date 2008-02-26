Return-Path: <linux-kernel-owner+w=401wt.eu-S1764807AbYBZWiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764807AbYBZWiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbYBZWin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:38:43 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:39480 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694AbYBZWim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:38:42 -0500
Subject: [PATCH 0/3] A kernel tracing interface
From: "David J. Wilder" <dwilder@us.ibm.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: systemtap@sourceware.org, prasadav@us.ibm.com, hch@infradead.org
Content-Type: text/plain
Date: Tue, 26 Feb 2008 14:38:37 -0800
Message-Id: <1204065517.26964.14.camel@lc4eb748232119.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-35.0.4.el4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches provide a kernel tracing interface called "trace".

ChangeLog:
-Updated to 2.6.25-rc2-mm1
-Removed sem_watch example, to hard to maintain.
-Added a new example that demonstrates per-cpu continuous tracing
 of data generated using marker probes.
-Removed inline from relay patch.
-Moved examples into /sample directory.

The motivation for "trace" is to:
- Provide a simple set of tracing primitives that will utilize the high-
  performance and low-overhead of relayfs for passing traces data from
  kernel to user space.
- Provide a common user interface for managing kernel traces.
- Allow for binary as well as ascii trace data.
- Incorporate features from the systemtap runtime that are
  useful to others.

Patches are built against 2.6.25-rc2-mm1.
Tested on: 2.6.25-rc3

Summary of patches:
[patch 1/3]  Relay Reset Consumed
[patch 2/3]  Trace code and documentation
[patch 3/3]  Trace sample

Note: Patch 1/3 provides a service used by patch 2/3
thus must be applied first or at the same time.

Signed-off-by: David Wilder <dwilder@us.ibm.com>


