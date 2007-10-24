Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbXJXTqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbXJXTqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 15:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbXJXTqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 15:46:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38371 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251AbXJXTqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 15:46:35 -0400
Date: Wed, 24 Oct 2007 21:46:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: Al Viro <viro@ftp.linux.org.uk>, gregkh@suse.de,
       David Brownell <dbrownell@users.sourceforge.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] usb: fix ssb_ohci_probe() build bug
Message-ID: <20071024194619.GA18309@elte.hu>
References: <20071014032948.GA25760@elte.hu> <20071015173840.GA26109@elte.hu> <20071015174321.GA27428@elte.hu> <200710152008.49590.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710152008.49590.mb@bu3sch.de>
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


* Michael Buesch <mb@bu3sch.de> wrote:

> >  CONFIG_SSB=m
> >  CONFIG_USB_OHCI_HCD=y
> >  CONFIG_USB_OHCI_HCD_SSB=y
> > 
> > the fix is to require a modular USB_OHCI_HCD build when SSB is modular.
> > 
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> Acked-by: Michael Buesch <mb@bu3sch.de>
> 
> Somebody of the USB folks apply this, please.

FYI, this build fix is still not in v2.6.24-rc1.

	Ingo
