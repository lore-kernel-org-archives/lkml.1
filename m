Return-Path: <linux-kernel-owner+w=401wt.eu-S1751721AbYANTJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbYANTJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbYANTJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:09:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46596 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbYANTJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:09:17 -0500
Date: Mon, 14 Jan 2008 20:09:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_32: remove warning message not used
Message-ID: <20080114190904.GA2288@elte.hu>
References: <478BB226.6090105@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478BB226.6090105@ct.jp.nec.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0015]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> smp_num_siblings hasn't been updated at this point yet, so it's always 
> 1. This polling and HT warning message is never shown.

hah, nice one. But could you perhaps move it to a place where it has a 
chance to be printed? The warning still makes sense.

	Ingo
