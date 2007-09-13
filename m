Return-Path: <linux-kernel-owner+w=401wt.eu-S1761232AbXIMXnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761232AbXIMXnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbXIMXnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:43:13 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41290 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068AbXIMXnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:43:12 -0400
Message-ID: <46E9CB0D.2040206@us.ibm.com>
Date: Thu, 13 Sep 2007 16:43:09 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, SystemTAP <systemtap@sources.redhat.com>
CC: akpm@linux-foundation.org
Subject: [PATCH 0/2] A kernel tracing interface
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

This patch addresses review comments made by Christoph Hellwig and Mathieu
Desnoyers.  Changes include the addition of a mutex and synchronization
protecting trace state changes (using RCU) and the reduction of the
number of exports.

Patches are against 2.6.23-rc4-mm1

Required patches:
1/2 Trace code and documentation
2/2 Relay reset consumed  (required for trace's "rewind" feature")

Signed-off-by: David Wilder <dwilder@us.ibm.com>

