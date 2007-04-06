Return-Path: <linux-kernel-owner+w=401wt.eu-S932768AbXDFTy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbXDFTy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932516AbXDFTxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:53:50 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:47667 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932564AbXDFTxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:53:45 -0400
Date: Fri, 6 Apr 2007 12:51:31 -0700
Message-Id: <200704061951.l36JpVdT008372@zach-dev.vmware.com>
Subject: [PATCH 0/3] i386 VMI fix for lazy MMU bug, take 3
From: Zachary Amsden <zach@vmware.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>
X-OriginalArrivalTime: 06 Apr 2007 19:53:43.0429 (UTC) FILETIME=[47D23350:01C77885]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In light of objections to the original fix I proposed for lazy MMU
interactions between VMI and kmap_atomic in interrupt context, I
have an updated patch series.

The first is for 2.6.21; it is an urgent bugfix, please apply.
The second backs out the first; it is required to avoid conflicts
  with later work which has been done on the paravirt-ops code.
  It should be added to subsystem queues which are being held
  for 2.6.22.
The third illustrates the form the fix will likely take after the paravirt-ops
  queue is applied, but is for demonstration purposes only.

Zach
