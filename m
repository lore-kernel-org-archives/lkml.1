Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbYKMTEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbYKMTEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:04:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbYKMTDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:03:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59599 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbYKMTDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:03:53 -0500
Date: Thu, 13 Nov 2008 20:03:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andres Salomon <dilinger@queued.net>
Cc: Pavel Machek <pavel@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       Jeremy Katz <katzj@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jordan Crouse <jordan.crouse@amd.com>, linux-kernel@vger.kernel.org,
       dsaxena@laptop.org
Subject: Re: [PATCH] ALSA: cs5535audio: only build OLPC support if
	MGEODE_LX is defined
Message-ID: <20081113190339.GE17851@elte.hu>
References: <20081109201710.4c490f04@debxo> <1226498050.12791.45.camel@aglarond.local> <s5hbpwlj9w1.wl%tiwai@suse.de> <1226547898.13077.83.camel@aglarond.local> <s5h63msru7z.wl%tiwai@suse.de> <20081113153714.GA1520@ucw.cz> <s5h3ahvhb9w.wl%tiwai@suse.de> <20081113111428.59aa36cb@ephemeral> <20081113163802.GA1734@ucw.cz> <20081113120147.2ecde3c8@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081113120147.2ecde3c8@ephemeral>
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


* Andres Salomon <dilinger@queued.net> wrote:

> On Thu, 13 Nov 2008 17:38:02 +0100
> Pavel Machek <pavel@suse.cz> wrote:
> 
> > On Thu 2008-11-13 11:14:28, Andres Salomon wrote:
> > > On Thu, 13 Nov 2008 16:54:19 +0100
> > > Takashi Iwai <tiwai@suse.de> wrote:
> > > 
> > > > At Thu, 13 Nov 2008 16:37:14 +0100,
> > > > Pavel Machek wrote:
> > > [...]
> > > > > 
> > > > > > IMO, the basic problem is rather that the platform and the CPU
> > > > > > selection is mixed up.  The geode GPIO stuff shouldn't belong
> > > > > > to CPU selection.
> > > > > 
> > > > > ACK... and suggested patch makes it worse.
> > > > > 
> > > > > There should be option 'support OLPC' somewhere, and that should
> > > > > enable the gpio bits. Alsa driver should depend on that one.
> > > > 
> > > > Any better fix patch is welcome, of course :)
> > > > This would make save a lot time than writing mails...
> > 
> > > 
> > > Okay, how about something like the following?
> > 
> > It is wrong. It is valid & useful to compile kernel for i386 and
> > expect all the features on OLPC (with small performance hit).
> 
> No one's debating that.  That requires additional work that will 
> take longer, however.

i've zapped this patch meanwhile:

 1355c96: x86/olpc: make CONFIG_OLPC dependent on CONFIG_MGEODE_LX

because it cripples the ability to run distribution kernels on the 
OLPC.

	Ingo
