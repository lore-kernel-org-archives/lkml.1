Return-Path: <linux-kernel-owner+w=401wt.eu-S1757816AbYABKIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816AbYABKIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 05:08:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbYABKHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 05:07:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53611 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678AbYABKHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 05:07:53 -0500
Date: Wed, 2 Jan 2008 11:00:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christer Weinigel <christer@weinigel.se>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       Rene Herman <rene.herman@gmail.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20080102100041.GA5888@elte.hu>
References: <4766AE88.4080904@zytor.com> <4766D175.7040807@reed.com> <20071217212509.5edaa372@the-village.bc.nu> <477A634C.8040000@reed.com> <20080101161557.3ce2d5f8@the-village.bc.nu> <20080101164338.GA901@elte.hu> <20080101183238.74307174@weinigel.se> <20080101184659.GA9250@elte.hu> <20080101203518.26e889f2@weinigel.se> <477AAEEB.5060407@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477AAEEB.5060407@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Christer Weinigel wrote:
>>
>> out 80h, al is only two bytes.  Any alternative that has been suggested
>> in this discussion will use more space.  mov dx, alt_port; out dx, al
>> will be larger, a function call will definitely be a lot larger. People
>> have been making changes to the kernel to save a couple of hundred
>> bytes of text size.
>>
>
> If text size becomes a problem in this case, then we can use an 
> alternatives-like mechanism to fix up the kernel.  However, 
> realistically this probably should be a function call *combined with* 
> the out and in; that reduces the impact somewhat.

and that's exactly what x86.git#mm does now.

	Ingo
