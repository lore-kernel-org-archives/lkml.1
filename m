Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbXJWPou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbXJWPou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbXJWPon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:44:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56536 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbXJWPom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:44:42 -0400
Date: Tue, 23 Oct 2007 17:44:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Al Viro <viro@ftp.linux.org.uk>,
       WANG Cong <xiyou.wangcong@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Nix <nix@esperi.org.uk>, Jeff Dike <jdike@addtoit.com>,
       Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in
	2.6.23-final.
Message-ID: <20071023154417.GA24016@elte.hu>
References: <471D2ECC.6090209@goop.org> <20071022231927.GA30814@elte.hu> <471D389E.40609@goop.org> <20071023084546.GA17007@elte.hu> <p73wste7zy5.fsf@bingen.suse.de> <20071023131009.GA32298@elte.hu> <p73sl427wvu.fsf@bingen.suse.de> <20071023142006.GA9961@elte.hu> <20071023144852.GA27956@one.firstfloor.org> <20071023151309.GA14998@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023151309.GA14998@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > [...] -pg should in theory work with -mregparms.
> 
> last i checked it didnt work - i'll re-check that.

earlier gcc versions had problems with -mregparm and with -pg. I just 
did a quick test with latest gcc and at a quick glance it seems to work 
better - i'll propagate that throught he whole latency tracer to see 
whether it's indeed working throughout. Anyway, this means that there's 
no urgent need for this patch and we've dropped it from the x86 queue 
for now. As long as it only affects older gcc's it's probably not worth 
force-keeping the annotations for that purpose alone.

	Ingo
