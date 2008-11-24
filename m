Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbYKXCf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbYKXCf5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 21:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYKXCf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 21:35:26 -0500
Received: from ozlabs.org ([203.10.76.45]:45318 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbYKXCfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 21:35:21 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18730.4823.146518.37665@drongo.ozlabs.ibm.com>
Date: Mon, 24 Nov 2008 13:35:03 +1100
From: Paul Mackerras <paulus@samba.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org,
       Milton Miller <miltonm@bga.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 5/5] powerpc/ppc32: ftrace, dynamic ftrace to handle modules
In-Reply-To: <20081120191149.959614508@goodmis.org>
References: <20081120190948.057007623@goodmis.org>
	<20081120191149.959614508@goodmis.org>
X-Mailer: VM 8.0.11 under Emacs 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt writes:

> This patch performs the necessary trampoline calls to handle
> modules with dynamic ftrace on 32 bit PowerPC.

Looks OK except for the need to call flush_icache_range after
probe_kernel_write, like in the 64-bit case.

Paul.
