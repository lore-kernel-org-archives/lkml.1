Return-Path: <linux-kernel-owner+w=401wt.eu-S1762983AbYBSJnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762983AbYBSJnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759048AbYBSJnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:43:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53227 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757842AbYBSJnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:43:17 -0500
Date: Tue, 19 Feb 2008 10:42:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "David P. Reed" <dpreed@reed.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rene Herman <rene.herman@keyaccess.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: define outb_pic and inb_pic to stop using outb_p
	and inb_p
Message-ID: <20080219094256.GC7628@elte.hu>
References: <6gr00g$g7qpsd@smtp01.lnh.mail.rcn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6gr00g$g7qpsd@smtp01.lnh.mail.rcn.net>
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


* David P. Reed <dpreed@reed.com> wrote:

> x86: define outb_pic and inb_pic to stop using outb_p and inb_p
>  
> The delay between io port accesses to the PIC is now defined using 
> outb_pic and inb_pic.  This fix provides the next step, using 
> udelay(2) to define the *PIC specific* timing requirements, rather 
> than on bus-oriented timing, which is not well calibrated.

thanks David, applied.

minor nit:

> +	/* delay for some accesses to PIC on motherboard or in chipset must be
> +	   at least one microsecond, but be safe here. */

i changed this to the standard multi-line comment style of:

> +	/*
> +      * Delay for some accesses to PIC on motherboard or in chipset 
> +      * must be at least one microsecond, but be safe here:
> +      */

	Ingo
