Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbZCKAqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbZCKAqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 20:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZCKAq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 20:46:26 -0400
Received: from www.tglx.de ([62.245.132.106]:39990 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbZCKAqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 20:46:25 -0400
Message-Id: <20090311003204.592133594@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 11 Mar 2009 00:45:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 00/18] Remove obsolete genirq defines and typedefs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The defines and typedefs (hw_interrupt_type, no_irq_type, irq_desc_t)
have been kept around for migration reasons. After more than two years
it's time to remove them finally.

This patch series cleans up the remaining users. When those patches
hit mainline we can remove the defines and typedefs finally.

Thanks,

	tglx

