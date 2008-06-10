Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbYFJRE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbYFJRE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbYFJREt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:04:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42444 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbYFJREt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:04:49 -0400
Date: Tue, 10 Jun 2008 19:14:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: sys32_sigsuspend()'s need for ptregs parameter
Message-ID: <20080610171446.GB29289@one.firstfloor.org>
References: <484E78CA.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484E78CA.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 11:51:22AM +0100, Jan Beulich wrote:
> ia32entry.S has a PTREGSCALL entry for sys32_sigsuspend(), yet the
> function doesn't have a struct pt_regs * parameter. What's setting up
> that argument good for? Or is this just a leftover?
> 
> Same would apply to sys_rt_sigsuspend().

Should be safe to remove.

-Andi
