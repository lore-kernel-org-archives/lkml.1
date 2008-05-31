Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbYEaMz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbYEaMz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 08:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbYEaMzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 08:55:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35077 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbYEaMzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 08:55:11 -0400
Date: Sat, 31 May 2008 14:54:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
Message-ID: <20080531125428.GA22111@elte.hu>
References: <20080526115628.GA31316@elte.hu> <20080529084524.GA24892@elte.hu> <Pine.LNX.4.64.0805291332401.16829@wrl-59.cs.helsinki.fi> <20080529112257.GA18130@elte.hu> <20080530181839.GA31915@elte.hu> <20080531060947.GA26441@elte.hu> <Pine.LNX.4.64.0805311431100.2329@wrl-59.cs.helsinki.fi> <Pine.LNX.4.64.0805311505410.2329@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0805311505410.2329@wrl-59.cs.helsinki.fi>
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


* Ilpo Järvinen <ilpo.jarvinen@helsinki.fi> wrote:

> > Btw, does your distcc perhaps happen enable TCP_DEFER_ACCEPT (there 
> > were some post 2.6.25 changes into it)?
> 
> Hmm, if so, please try this revert below (I hope I got everything that 
> is related there, gitk is currently broken for me so that viewing many 
> commits quickly is a pain, so I might have accidently missed 
> something)...

what is the easiest way to figure out whether my version of distcc 
enables TCP_DEFER_ACCEPT?

	Ingo
