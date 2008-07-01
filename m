Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbYGAG6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbYGAG6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 02:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYGAG56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 02:57:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52407 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbYGAG55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 02:57:57 -0400
Date: Tue, 1 Jul 2008 08:56:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Andy Whitcroft <apw@shadowen.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Vivek Goyal <vgoyal@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [BUILD-FAILURE] linux-next: Tree for June 30
Message-ID: <20080701065614.GA26601@elte.hu>
References: <20080701001656.e156585c.sfr@canb.auug.org.au> <48690385.7030500@linux.vnet.ibm.com> <48690D3C.1060803@linux.vnet.ibm.com> <20080630185943.GA24692@uranus.ravnborg.org> <20080630192610.GA6584@elte.hu> <20080630194727.GA26682@uranus.ravnborg.org> <20080630200623.GE6584@elte.hu> <20080630202506.GA28050@uranus.ravnborg.org> <486943F1.80606@zytor.com> <48695449.5010602@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48695449.5010602@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Here is a patch to replace the hard-coded limit with dynamic 
> allocation.
>  I have only build-tested it, but it seems to work.
>
> Please try it out; barring any screams to the contrary I'll add it to 
> -tip.

it's looking good here too in my testing.

I dont think there's a v2.6.26 urgency as the first time we've ever seen 
this warning was in linux-next. If it passes testing i agree that it's 
good for v2.6.27.

	Ingo
