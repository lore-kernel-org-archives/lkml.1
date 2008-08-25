Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbYHYG2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbYHYG2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 02:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbYHYG1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 02:27:54 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:19672 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753700AbYHYG1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 02:27:53 -0400
Date: Mon, 25 Aug 2008 15:27:43 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] sh: fix ptrace_64.c:user_disable_single_step()
Message-ID: <20080825062743.GB19834@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080822152036.GB26762@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822152036.GB26762@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 06:20:36PM +0300, Adrian Bunk wrote:
> This patch fixes the following compile error caused by
> commit c459dbf294b4a3d70490a468a7ca3907fb2c2f57
> (sh: ptrace single stepping cleanups.):
> 
> <--  snip  -->
> 
> ...
>   CC      arch/sh/kernel/ptrace_64.o
> arch/sh/kernel/ptrace_64.c: In function 'user_disable_single_step':
> arch/sh/kernel/ptrace_64.c:134: error: 'regs' undeclared (first use in this function)
> arch/sh/kernel/ptrace_64.c:134: error: (Each undeclared identifier is reported only once
> arch/sh/kernel/ptrace_64.c:134: error: for each function it appears in.)
> ...
> make[2]: *** [arch/sh/kernel/ptrace_64.o] Error 1
> 
> <--  snip  -->
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
Applied, thanks.
