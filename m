Return-Path: <linux-kernel-owner+w=401wt.eu-S1756424AbYKKNx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbYKKNx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 08:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbYKKNxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 08:53:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49164 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754906AbYKKNxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 08:53:20 -0500
Date: Tue, 11 Nov 2008 14:53:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Takashi Iwai <tiwai@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Jordan Crouse <jordan.crouse@amd.com>,
       Andres Salomon <dilinger@debian.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 - Make CONFIG_OLPC dependent on CONFIG_MGEODE_LX
Message-ID: <20081111135306.GA32709@elte.hu>
References: <s5h3ahyqwmn.wl%tiwai@suse.de> <20081111125402.GB14989@elte.hu> <s5hzlk6pea6.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hzlk6pea6.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Takashi Iwai <tiwai@suse.de> wrote:

> At Tue, 11 Nov 2008 13:54:02 +0100,
> Ingo Molnar wrote:
> > 
> > 
> > * Takashi Iwai <tiwai@suse.de> wrote:
> > 
> > > The OLPC-specpfic codes require geode_gpio_*() functions although
> > > these functions are defined only with CONFIG_MGEODE_LX=y.
> > > Add a proper dependency to fix build errors.
> > > 
> > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > 
> > hm, could you please send a .config that shows the build errors?
> 
> Here it is.  It's for today's linux-next.

hm, which tree did that build failure in linux-next originate from? 
Your config builds fine here with the latest x86 tree.

	Ingo
