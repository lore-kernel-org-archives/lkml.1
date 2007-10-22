Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbXJVJmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbXJVJmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbXJVJmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:42:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59109 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbXJVJmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:42:00 -0400
Subject: Re: 100% iowait on one of cpus in current -git
From: Peter Zijlstra <peterz@infradead.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200710220822.52370.maximlevitsky@gmail.com>
References: <200710220822.52370.maximlevitsky@gmail.com>
Content-Type: text/plain
Date: Mon, 22 Oct 2007 11:41:57 +0200
Message-Id: <1193046118.27435.166.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-22 at 08:22 +0200, Maxim Levitsky wrote:
> Hi,
> 
> I found a bug in current -git:
> 
> On my system on of cpus stays 100% in iowait mode (I have core 2 duo)
> Otherwise the system works OK, no disk activity and/or slowdown.
> Suspecting that this is a swap-related problem I tried to turn swap of, but it doesn't affect anything.
> It is probably some accounting bug.
> 
> If I start with init=/bin/bash, then this disappears.
> I tried then to start usual /etc/init.d scripts then, and first one to show this bug was gpm.
> but then I rebooted the system to X without gpm, and I still see 100% iowait.
> 
> No additional messages in dmesg.

does sysrq-t show any D state tasks?

