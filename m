Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbYL2RTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbYL2RTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 12:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYL2RTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 12:19:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55990 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbYL2RTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 12:19:05 -0500
Date: Mon, 29 Dec 2008 18:18:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: reboot.c declare port_cf9_safe before they get
	used
Message-ID: <20081229171852.GA26313@elte.hu>
References: <1230049288.14358.4.camel@jaswinder.satnam> <1230540199.3715.11.camel@jaswinder.satnam> <20081229110855.GA5065@elte.hu> <200812290909.36751.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812290909.36751.jbarnes@virtuousgeek.org>
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


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> > Jesse, is it fine to you if we push this via the x86 tree? A couple of 
> > usage sites of arch/x86/pci/pci.h arose that use ../pci/pci.h kind of 
> > ugly
> > #include prefixes, which justifies moving the file to
> > arch/x86/include/asm. No change in behavior.
> 
> Yeah, that's fine.  Best to get it over with... I'll take care of any 
> conflicts in my tree when I prepare my merge.

thanks - i've added your ack. Should go Linus-wards within the next few 
days.

	Ingo
