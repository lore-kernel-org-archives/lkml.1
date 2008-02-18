Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbYBRDMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbYBRDMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 22:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbYBRDM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 22:12:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52676 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbYBRDM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 22:12:27 -0500
Date: Mon, 18 Feb 2008 04:12:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: fix pcspkr to not use inb_p/outb_p calls.
Message-ID: <20080218031202.GD30201@elte.hu>
References: <6gr00g$g7cmat@smtp01.lnh.mail.rcn.net> <20080217222329.1152d689@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217222329.1152d689@core>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Sun, 17 Feb 2008 16:56:42 -0500 (EST)
> "David P. Reed" <dpreed@reed.com> wrote:
> 
> > Fix pcspkr driver to use explicit timing delay for access to PIT,
> > rather than inb_p/outb_p calls, which use insufficiently explicit
> 
> NAK.
> 
> We now have inb_pit and outb_pit to make the transition easier - can 
> you switch to those instead of coding internal knowledge outside of 
> the kernel methods.

please also Cc: Dmitry Torokhov <dtor_core@ameritech.net> to 
drivers/input/ patches. Once inb_pit/outb_pit is used, as suggested by 
Alan, i ack the patch from the arch/x86 perspective.

	Ingo
