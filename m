Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbXJBSz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbXJBSz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 14:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbXJBSzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 14:55:51 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36874 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693AbXJBSzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 14:55:50 -0400
Subject: [PATCH 0/3] A kernel tracing interface
From: "David J. Wilder" <dwilder@us.ibm.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: randy.dunlap@oracle.com, hch@infradead.org, systemtap@sources.redhat.com
Content-Type: text/plain
Date: Tue, 02 Oct 2007 11:55:46 -0700
Message-Id: <1191351347.31351.18.camel@lc4eb748232119.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These patches provide a kernel tracing interface called "trace".

(update) Updated documentation and added configuration dependency
on KPROBES for trace sample code.

The motivation for "trace" is to:
- Provide a simple set of tracing primitives that will utilize the high-
  performance and low-overhead of relayfs for passing traces data from
  kernel to user space.
- Provide a common user interface for managing kernel traces.
- Allow for binary as well as ascii trace data.
- Incorporate features from the systemtap runtime that are
  useful to others.

Patches are against 2.6.23-rc8-mm2

Summary of patches:
[patch 1/3]  Trace code and documentation
[patch 2/3]  Relay Reset Consumed
[patch 3/3]  Trace sample

Note: Patch 2/3 provides a service used by patch 1/3
thus must be applied first or at the same time.

Note: The following patches must be applied prior to 3/3.
[patch 3/5] Add samples subdir
	http://lkml.org/lkml/2007/9/28/178

[patch 4/5] Linux Kernel Markers - Samples
	http://lkml.org/lkml/2007/9/28/189

Signed-off-by: David Wilder <dwilder@us.ibm.com>


