Return-Path: <linux-kernel-owner+w=401wt.eu-S1751891AbYIWLUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbYIWLUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 07:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbYIWLTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 07:19:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56974 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbYIWLTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 07:19:52 -0400
Date: Tue, 23 Sep 2008 13:19:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [GIT-PULL] Split time.c series: part 1
Message-ID: <20080923111935.GK29021@elte.hu>
References: <200809221857.m8MIvXUB019029@ns3.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809221857.m8MIvXUB019029@ns3.rdu.redhat.com>
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


* Glauber Costa <gcosta@redhat.com> wrote:

> Ingo, please pull the latest master branch git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/glommer/linux-2.6-x86-integration.git ingo-time
> 
> into your tree

hm, there's no ingo-time branch there. Forgot to push out? But the 
'master' branch seems to match up with your diffstat, so i pulled that 
one instead.

> It contains the part of time.c integration that is considered mostly 
> safe, and does not touch (but one reorganization patch) the interrupt 
> code. It should go smootly, but it's (should be) bisection friendly in 
> case it doesn't.

i've restructured the dependencies a bit: i've put your changes into 
tip/x86/time and based them on tip/x86/core (not tip/master). It 
integrates cleanly into tip/master and i've started testing them.

Thanks,

	Ingo
