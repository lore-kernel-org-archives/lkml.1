Return-Path: <linux-kernel-owner+w=401wt.eu-S933853AbXDASjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853AbXDASjc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933855AbXDASjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:39:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37614 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933853AbXDASjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:39:31 -0400
Date: Sun, 1 Apr 2007 20:39:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rui Nuno Capela <rncbc@rncbc.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: 2.6.21-rc5-rt6 make errors
Message-ID: <20070401183928.GB27614@elte.hu>
References: <23932.213.58.131.130.1170156409.squirrel@www.rncbc.org> <460FE7F3.4060303@rncbc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <460FE7F3.4060303@rncbc.org>
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


* Rui Nuno Capela <rncbc@rncbc.org> wrote:

> Hi,
> 
> Just tried to build 2.6.21-rc5-rt6 and it is failing on build time.

> Just to let you know that -rt5 was doing fine with very same .config .

oops - indeed! I've uploaded -rc5-rt7 with the fix. (it includes a few 
other fixes as well)

note that for Fedora-ish distros there's an easy yum test-kernel 
available from the rt-testing repo:

cat > /etc/yum.repos.d/rt-testing.repo
[rt-testing]
name=Ingo's Real-Time (-rt) test-kernel for FC6
baseurl=http://people.redhat.com/mingo/realtime-preempt/yum-testing/yum/
enabled=1
gpgcheck=0
<Ctrl-D>

this includes Linus-git-bleeding-edge as well as the base kernel. (rt7 
is based on upstream HEAD 755948cfca16c7)

[the rt-testing repo currently includes the rt6 rpm, i've just started 
the rt7 build, it should be available in half an hour or so]

	Ingo
