Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbYLZN1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbYLZN1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 08:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbYLZN1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 08:27:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32971 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbYLZN1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 08:27:41 -0500
Date: Fri, 26 Dec 2008 14:27:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Wang Chen <wangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 -tip] irq: remove unneeded desc->chip->ack check
Message-ID: <20081226132730.GA29265@elte.hu>
References: <4954A02B.4060606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4954A02B.4060606@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0744]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wang Chen <wangchen@cn.fujitsu.com> wrote:

> desc->chip->ack is initialized to ack_bad().
> It will not be NULL.

hm, that is only true of no_irq_chip() - is it true of all irq_chip 
definitions on all architectures?

	Ingo
