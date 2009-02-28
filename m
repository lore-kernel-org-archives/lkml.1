Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbZB1Gl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbZB1Gl7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 01:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbZB1Glu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 01:41:50 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53558 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbZB1Glt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 01:41:49 -0500
Date: Sat, 28 Feb 2009 15:40:44 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Uwe Kleine-Konig <u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] make CALLER_ADDRx overwriteable
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1235766603-25206-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <alpine.DEB.2.00.0902271021370.25593@gandalf.stny.rr.com> <1235766603-25206-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-Id: <20090228153853.6FC0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The current definition of CALLER_ADDRx isn't suitable for all platforms.
> E.g. for ARM __builtin_return_address(N) doesn't work for N > 0 and
> AFAIK for powerpc there are no frame pointers needed to have a working
> __builtin_return_address.  This patch allows defining the CALLER_ADDRx
> macros in <asm/ftrace.h> and let these take precedence.
> 
> Because now <asm/ftrace.h> is included unconditionally in
> <linux/ftrace.h> all archs that don't already had this include get an
> empty one for free.
> 
> Signed-off-by: Uwe Kleine-Konig <u.kleine-koenig@pengutronix.de>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> --
> Hello,
> 
> OK, changed to check for HAVE_ARCH_CALLER_ADDR instead of CALLER_ADDR0.
> 
> Best regards
> Uwe

thanks.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




