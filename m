Return-Path: <linux-kernel-owner+w=401wt.eu-S966282AbXDGSwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966282AbXDGSwn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 14:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966287AbXDGSwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 14:52:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45081 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966282AbXDGSwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 14:52:42 -0400
Date: Sat, 7 Apr 2007 20:52:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Subject: Re: Ten percent test
Message-ID: <20070407185220.GA31725@elte.hu>
References: <200703290237.38777.kernel@kolivas.org> <200704071212.57401.gene.heskett@gmail.com> <20070407180818.GB23861@elte.hu> <200704071423.47790.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704071423.47790.gene.heskett@gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Gene Heskett <gene.heskett@gmail.com> wrote:

> Yes it would be Ingo, but so far, none of the recent -rt patches has 
> booted on this machine, the last one I tried a few days ago failing to 
> find /dev/root, whatever the heck that is.

did you have a chance to try the yum kernel by any chance? The -testing 
one you can try on Fedora with little hassle, by doing this as root:

cat > /etc/yum.repos.d/rt-testing.repo
[rt-testing]
name=Ingo's Real-Time (-rt) test-kernel for FC6
baseurl=http://people.redhat.com/mingo/realtime-preempt/yum-testing/yum/
enabled=1
gpgcheck=0
<Ctrl-D>

and "yum install kernel-rt" and a reboot should get you going.

> [...]  I don't enjoy sitting through all these e2fsk's during the 
> reboot just to have things I normally run in the background die, like 
> tvtime, sitting there with some news channel muttering along in the 
> background.  I was even ignored when I suggested it might be a dma 
> problem, which I still think it could be.

i did spend quite some time to debug your tv-tuner problem back then, 
and for that purpose alone i bought a tv tuner card to test this myself. 
(but it worked on my testbox)

	Ingo
