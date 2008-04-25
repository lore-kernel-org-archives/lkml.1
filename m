Return-Path: <linux-kernel-owner+w=401wt.eu-S1762244AbYDYPMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762244AbYDYPMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 11:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbYDYPM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 11:12:29 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37658 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbYDYPM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 11:12:28 -0400
Date: Fri, 25 Apr 2008 17:12:27 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: add statics, don't return void expressions
In-Reply-To: <1209127332.32291.1.camel@lappy>
Message-ID: <alpine.LNX.1.10.0804251711400.6645@fbirervta.pbzchgretzou.qr>
References: <1209086275.20088.4.camel@brick>  <1209125826.24931.12.camel@lappy>  <alpine.LNX.1.10.0804251431510.6645@fbirervta.pbzchgretzou.qr> <1209127332.32291.1.camel@lappy>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-04-25 14:42, Peter Zijlstra wrote:
>
>Sure, but this was just to show the idiom at hand; an actual use case
>would be something like this:
>
>void bar(void)
>{
>	if (cond)
>		return foo();
>
>	/* do stuff ourselves */
>}
>
>Leaving out the return here does have side-effects.
>
Of course. You do not get that luxury in the middle of the function :^)
