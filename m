Return-Path: <linux-kernel-owner+w=401wt.eu-S1752452AbYKRCgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbYKRCgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 21:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYKRCg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 21:36:29 -0500
Received: from ozlabs.org ([203.10.76.45]:38945 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYKRCg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 21:36:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18722.10784.719186.434130@cargo.ozlabs.ibm.com>
Date: Tue, 18 Nov 2008 13:36:16 +1100
From: Paul Mackerras <paulus@samba.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Large stack usage in fs code (especially for PPC64)
In-Reply-To: <alpine.DEB.1.10.0811172128380.26123@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com>
	<alpine.DEB.1.10.0811171557370.26123@gandalf.stny.rr.com>
	<alpine.DEB.1.10.0811172128380.26123@gandalf.stny.rr.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt writes:

> By-the-way, my box has been running stable ever since I switched to 
> CONFIG_IRQSTACKS.

Great.  We probably should remove the config option and just always
use irq stacks.

Paul.
