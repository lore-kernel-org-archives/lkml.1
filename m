Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbYBRNry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbYBRNry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYBRNrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:47:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37780 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbYBRNrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:47:45 -0500
Date: Mon, 18 Feb 2008 14:47:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Shi Weihua <shiwh@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 1/5] signal(x86_32): Improve the signal stack overflow
	check
Message-ID: <20080218134720.GA28851@elte.hu>
References: <47B95C4D.6080000@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B95C4D.6080000@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Shi Weihua <shiwh@cn.fujitsu.com> wrote:

> We need to check for stack overflow only when the signal is on stack. 
> So we can improve the patch "http://lkml.org/lkml/2007/11/27/101" as 
> following.

hm, does this address Roland's observations at:

   http://lkml.org/lkml/2007/11/28/13

?

	Ingo
