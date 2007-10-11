Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbXJKQXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbXJKQXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 12:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbXJKQXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 12:23:32 -0400
Received: from mail.exegy.com ([209.83.156.2]:1788 "EHLO mail.exegy.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752461AbXJKQXb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 12:23:31 -0400
Thread-Index: AcgMIw+RR7sTX9JgShWJ2xXehXKcNw==
X-Ninja-AntiSpoofing: spoofed
Message-ID: <470E4E02.4000504@exegy.com>
Date: Thu, 11 Oct 2007 11:23:30 -0500
From: "Mr. Berkley Shands" <bshands@exegy.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: "Nick Piggin" <nickpiggin@yahoo.com.au>, <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23 spinlock hang in kswapd under heavy disk write loads
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Content-class: urn:content-classes:message
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4073
Importance: normal
X-OriginalArrivalTime: 11 Oct 2007 16:23:30.0357 (UTC) FILETIME=[0F812650:01C80C23]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With DEBUG_SLAB on, I can run only a very short time under 2.6.23
before a kernel panic.

[  626.028180] eth0: too many iterations (6) in nv_nic_irq.
[  626.167583] eth0: too many iterations (6) in nv_nic_irq.
[  626.206729] eth0: too many iterations (6) in nv_nic_irq.
[  626.400171] eth0: too many iterations (6) in nv_nic_irq.
[  626.446374] eth0: too many iterations (6) in nv_nic_irq.

followed by the crash at
forcedeth:nv_nic_irq_optimized+0x89
handle_IRQ_event+0x25
handle_edge_IRQ+0xe3
do_IRQ

berkley
 
This e-mail and any documents accompanying it may contain legally privileged and/or confidential information belonging to Exegy, Inc. Such information may be protected from disclosure by law. The information is intended for use by only the addressee. If you are not the intended recipient, you are hereby notified that any disclosure or use of the information is strictly prohibited. If you have received this e-mail in error, please immediately contact the sender by e-mail or phone regarding instructions for return or destruction and do not use or disclose the content to others.
