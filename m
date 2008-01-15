Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbYAOM4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbYAOM4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYAOM4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:56:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59390 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbYAOM4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:56:14 -0500
Date: Tue, 15 Jan 2008 13:55:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: unify pagetable accessors patch causes double fault II
Message-ID: <20080115125556.GA3475@elte.hu>
References: <20080114094814.GA28300@basil.nowhere.org> <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu> <20080114135811.GA16190@one.firstfloor.org> <478BDC43.6050105@goop.org> <20080114222349.GA23409@one.firstfloor.org> <478BE628.7090008@goop.org> <20080115010534.GA24854@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115010534.GA24854@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> I just applied over the whole git-x86 patchkit (tip 
> 2f42671697ea9abc7d10ea7f663d6ef6e8ec6358) + the two build fixes 
> Unfortunately it didn't work, although the faulting loop is shorter 
> now:
> 
> Freeing unused kernel memory: 260k freed
> mount[1159]: segfault at b7fcfe98 ip b7ec6b7a sp bfcfcdec error 7
> Eeek! page_mapcount(page) went negative! (-1)

could you please send me the .config you are using on that kernel?

	Ingo
