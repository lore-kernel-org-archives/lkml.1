Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbYKQXEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbYKQXEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 18:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbYKQXEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 18:04:37 -0500
Received: from gate.crashing.org ([63.228.1.57]:46925 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbYKQXEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 18:04:36 -0500
Subject: Re: Large stack usage in fs code (especially for PPC64)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Tue, 18 Nov 2008 10:03:25 +1100
Message-Id: <1226963005.7178.248.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-17 at 15:34 -0500, Steven Rostedt wrote:
> Note, I was using a default config that had CONFIG_IRQSTACKS off and
> CONFIG_PPC_64K_PAGES on.

For one, we definitely need to turn IRQSTACKS on by default ... In fact,
I'm pondering just removing the option.

Cheers,
Ben.


