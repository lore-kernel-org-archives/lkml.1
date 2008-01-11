Return-Path: <linux-kernel-owner+w=401wt.eu-S1760952AbYAKOEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760952AbYAKOEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 09:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbYAKOD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 09:03:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55482 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317AbYAKOD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 09:03:58 -0500
Date: Fri, 11 Jan 2008 15:03:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "mboton@gmail.com" <mboton@gmail.com>
Subject: Re: hwclock failure in x86.git
Message-ID: <20080111140346.GA13604@elte.hu>
References: <4786AA11.5010805@gmail.com> <4786AB1B.4030004@zytor.com> <4786AF4C.6050509@gmail.com> <4786C2CF.4070204@zytor.com> <20080110220444.4c9efdec.kjwinchester@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110220444.4c9efdec.kjwinchester@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kevin Winchester <kjwinchester@gmail.com> wrote:

> Bisect says...
> 
> 4b5ea240a0c05ff90c4959fd91f0caec7b9bef1b is first bad commit
> commit 4b5ea240a0c05ff90c4959fd91f0caec7b9bef1b
> Author: mboton@gmail.com <mboton@gmail.com>
> Date:   Wed Jan 9 13:31:11 2008 +0100
> 
>     x86: ioport_{32|64}.c unification

thanks for tracking it down. I pulled that commit for now. But it would 
be nice to figure out what's going on there.

	Ingo
