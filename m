Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbZBKPQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbZBKPQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 10:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbZBKPQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 10:16:47 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36654 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230AbZBKPQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:16:47 -0500
Subject: Re: [PATCH RT 0/4] sh arch support for 2.6.28-rt
From: Steven Rostedt <srostedt@redhat.com>
To: Katsuya Matsubara <matsu@igel.co.jp>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1234364503-857-1-git-send-email-matsu@igel.co.jp>
References: <1234364503-857-1-git-send-email-matsu@igel.co.jp>
Content-Type: text/plain
Organization: Red Hat
Date: Wed, 11 Feb 2009 10:16:21 -0500
Message-Id: <1234365381.31601.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2009-02-12 at 00:01 +0900, Katsuya Matsubara wrote:
> These patches apply preempt-rt treatments into sh specific code.
> 64 bit support is not included because I have no sh64 board.
> These are based on the 2.6.28-rt git.
> 
> I made sure that these work on renesas rts7751r2dplus.
> 
> -- Katsuya Matsubara / matsu@igel.co.jp
> 
> ---
> 
> Katsuya Matsubara (4):
>   sh: use __preempt_enable_no_resched in cpu_idle()
>   sh: enable interrupts in signal handling
>   sh: decouple the pagefault-disabled logic
>   convert-locks-list: add sh specific spin locks

Applied. Thanks!

-- Steve


