Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbXISErR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbXISErR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 00:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbXISErD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 00:47:03 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44115 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbXISErA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 00:47:00 -0400
Subject: [Patch 0/2] A Kernel Tracing Interface (updated)
From: "David J. Wilder" <dwilder@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Content-Type: text/plain
Date: Tue, 18 Sep 2007 21:46:55 -0700
Message-Id: <1190177215.3190.17.camel@lc4eb748232119.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These patches provide a kernel tracing interface called "trace".

The motivation for "trace" is to:
- Provide a simple set of tracing primitives that will utilize the high-
  performance and low-overhead of relayfs for passing traces data from
  kernel to user space.
- Provide a common user interface for managing kernel traces.
- Allow for binary as well as ascii trace data.
- Incorporate features from the systemtap runtime that are
  useful to others.

History- Versions of this code have been submitted for review under
a couple of different names.  The original submission was called UTT,
it was later re-submitted as GTSC.   Christoph Hellwig commented "The
code looks fine ...but the name is just dumb".  Following Christoph's
advice, I changed the name to simply "Trace".

This patch addresses review comments made by Christoph Hellwig and
Mathieu Desnoyers.  Changes include the addition of a mutex and
synchronization protecting trace state changes (using RCU) and the
reduction of the number of exports.

Patch Updated Sep. 18,2007
Addressed further review comments by Andrew Morton, Randy Dunlap,
and Sam Ravnborg.

Patches are against 2.6.23-rc6-mm1

Required patches:
1/2 Trace code and documentation
2/2 Relay Reset Consumed patch (required for trace's "rewind" feature")

Signed-off-by: David Wilder <dwilder@us.ibm.com>


