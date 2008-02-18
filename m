Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbYBRDIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbYBRDIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 22:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbYBRDIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 22:08:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39344 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbYBRDID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 22:08:03 -0500
Date: Mon, 18 Feb 2008 04:07:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: fix cmos read and write to not use inb_p and
	outb_p
Message-ID: <20080218030743.GC30201@elte.hu>
References: <6gr00g$g7cm9p@smtp01.lnh.mail.rcn.net> <20080217222440.32aeb055@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217222440.32aeb055@core>
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

> On Sun, 17 Feb 2008 16:56:39 -0500 (EST)
> "David P. Reed" <dpreed@reed.com> wrote:
> 
> > fix code to access CMOS rtc registers so that it does not use inb_p and
> > outb_p routines, which are deprecated.
> 
> > Signed-off-by: David P. Reed <dpreed@reed.com>
> 
> Acked-by: Alan Cox <alan@redhat.com>

thanks, i've queued this up in x86.git.

	Ingo
