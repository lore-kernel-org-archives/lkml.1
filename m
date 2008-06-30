Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbYF3Son@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbYF3Son (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbYF3Sod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:44:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58782 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbYF3Soc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:44:32 -0400
Date: Mon, 30 Jun 2008 20:44:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <npiggin@suse.de>, Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Stephen Tweedie <sct@redhat.com>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for
	64-bit Xen support
Message-ID: <20080630184404.GA20566@elte.hu>
References: <4863A8E6.1010807@goop.org> <20080627160333.GA27072@elte.hu> <486539A3.3030102@goop.org> <20080629084318.GA28815@elte.hu> <48684CD4.7040403@goop.org> <20080630082135.GA22844@elte.hu> <20080630092209.GA29815@elte.hu> <48691524.5010806@goop.org> <20080630181221.GF23739@elte.hu> <486927AB.1060006@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486927AB.1060006@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>> try 'make ARCH=i386 oldconfig' - does it work better that way?
>
> Er, we're talking about 64-bit here, aren't we?  The log messages are 
> from a 64-bit kernel.
>
> Well, it was the wrong config anyway, which I guess is the source of 
> this confusion.

yeah.

> (I thought ARCH= to select 32/64 was going away now that the config 
> has the bitsize config?)

yep, correct - but it has to be done carefully - until now people (and 
tools) could assume that 'make oldconfig' just creates stuff for their 
native host architecture. But i agree in principle.

	Ingo
