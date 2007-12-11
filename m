Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbXLKPw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbXLKPw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 10:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbXLKPwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 10:52:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59081 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbXLKPwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 10:52:38 -0500
Date: Tue, 11 Dec 2007 16:52:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jie Chen <chen@jlab.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Possible bug from kernel 2.6.22 and above, 2.6.24-rc4
Message-ID: <20071211155226.GA1056@elte.hu>
References: <20071205204645.GC25694@elte.hu> <47570F83.6040601@jlab.org> <20071205210222.GA30089@elte.hu> <47572353.4040606@jlab.org> <20071206104318.GB30838@elte.hu> <47582367.6060602@jlab.org> <20071210105943.GA5370@elte.hu> <475D9BB5.20808@jlab.org> <20071211105149.GA24250@elte.hu> <475EAC81.1020408@jlab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475EAC81.1020408@jlab.org>
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


* Jie Chen <chen@jlab.org> wrote:

> Hi, Ingo:
>
> I guess it is a good news. I did patch 2.6.21.7 kernel using your cfs 
> patch. The results of pthread_sync is the same as the non-patched 
> 2.6.21 kernel. This means the performance of is not related to the 
> scheduler. As for overhead of the gettimeofday, there is no difference 
> between 2.6.21 and 2.6.24-rc4. The reference time is around 10.5 us 
> for both kernel.

could you please paste again the relevant portion of the output you get 
on a "good" .21 kernel versus the output you get on a "bad" .24 kernel?

> So what is changed between 2.6.21 and 2.6.22? Any hints :-). Thank you 
> very much for all your help.

we'll figure it out i'm sure :)

	Ingo
