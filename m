Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYINMLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYINMLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 08:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYINMLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 08:11:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50032 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbYINMLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 08:11:03 -0400
Date: Sun, 14 Sep 2008 14:10:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 0/3] acpi/x86: __apci_unmap_table and early_ioremap
	cleanup v3
Message-ID: <20080914121043.GC16097@elte.hu>
References: <1221334101-6464-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221334101-6464-1-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> remove the map/unmap and nesting requirement. and early acpi tables 
> could map more table at same time if needed. also could unmap them out 
> of order.

great cleanup and enhancement - applied them to tip/x86/core:

 175927a: x86: check dsdt before find oem table for es7000, v2
 5560cb0: acpi/x86: introduce __apci_map_table, v4
 3be54ff: x86: change early_ioremap to use slots instead of nesting

	Ingo
