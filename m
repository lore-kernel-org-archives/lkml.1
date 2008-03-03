Return-Path: <linux-kernel-owner+w=401wt.eu-S1752888AbYCCXwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbYCCXwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 18:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbYCCXvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 18:51:46 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43266 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbYCCXvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 18:51:45 -0500
Subject: [PATCH 0/3] A kernel tracing interface (updated)
From: "David J. Wilder" <dwilder@us.ibm.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: systemtap@sourceware.org
Content-Type: text/plain
Date: Mon, 03 Mar 2008 15:51:39 -0800
Message-Id: <1204588300.32186.6.camel@lc4eb748232119.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-35.0.4.el4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches provide a kernel tracing interface called "trace".

ChangeLog:
-Added "Examples of user interface" to doc.
-Fix state write to match only on exact commands.
-Updated to 2.6.25-rc2-mm1
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


