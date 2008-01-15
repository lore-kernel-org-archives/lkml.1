Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbYAOS4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbYAOS4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 13:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYAOS4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 13:56:46 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:17450 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbYAOS4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 13:56:45 -0500
Message-ID: <478D01E4.8010000@ct.jp.nec.com>
Date: Tue, 15 Jan 2008 10:56:36 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] x86: move warning message of polling idle and HT enabled,
 take 3
References: <478BB226.6090105@ct.jp.nec.com> <20080114190904.GA2288@elte.hu> <478C1475.7060706@ct.jp.nec.com> <20080115132607.GE7025@elte.hu>
In-Reply-To: <20080115132607.GE7025@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set for printing properly the warning message;
"polling idle and HT enabled, performance may degrade"

The warning message is never shown because smp_num_sibling hasn't
been updated yet at idle_setup().
So I moved the warning to select_idle_routine() and made it called
after detect_ht().

It also needs Andi's patch for 32-bit.
i386: Move MWAIT idle check to generic CPU
http://lkml.org/lkml/2008/1/2/358

[PATCH 1/2] x86: move warning message of polling idle and HT enabled
[PATCH 2/2] x86_64: move select_idle_routine() call after detect_ht()

Thanks,
Hiroshi Shimamoto
