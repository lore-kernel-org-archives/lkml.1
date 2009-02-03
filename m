Return-Path: <linux-kernel-owner+w=401wt.eu-S1752843AbZBCFMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbZBCFMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 00:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbZBCFME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 00:12:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52016 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbZBCFMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 00:12:03 -0500
Date: Tue, 3 Feb 2009 06:11:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix kexec with vmlinux
Message-ID: <20090203051151.GA28361@elte.hu>
References: <49878B88.8050602@kernel.org> <4987A8F3.1010702@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4987A8F3.1010702@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: fix regression with kexec with vmlinux
> 
> split data.init into data.init, percpu, data.init2 sections
> instead of let data.init wrap percpu secion.
> 
> so kexec loading will be happy that there will not have overlapping.

Applied to tip/core/percpu, thanks Yinghai!

	Ingo
