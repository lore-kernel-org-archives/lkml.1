Return-Path: <linux-kernel-owner+w=401wt.eu-S935110AbXLQWDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935110AbXLQWDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761575AbXLQWDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:03:09 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:33109 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbXLQWDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:03:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=XVKG9ue2RLmFjyjha1qq52H1a81cCM83BEvr8BnwVVDt3cOJ2kGfA7K9hxXCZT6jgx2o/xFdU8AvGPSdFYxjktrVvwvCc0DgXvp1AKYVEci8bLI434DoRiHDG/lb66O/kHAJtGGAbu/0XzM8H7hg3NkMSlezpI3YsTvi2vaSNPs=
Message-ID: <4766F1AE.4060601@keyaccess.nl>
Date: Mon, 17 Dec 2007 23:01:18 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rene Herman <rene.herman@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <20071217105744.GA14315@elte.hu> <4766684D.40202@gmail.com> <20071217130933.GB27992@elte.hu> <47667812.8050708@gmail.com> <47667A85.3080100@reed.com> <20071217143900.GA16604@elte.hu> <20071217161243.05c32df4@the-village.bc.nu> <4766E086.9090500@gmail.com> <20071217214139.GC22828@elte.hu> <4766EE79.90003@keyaccess.nl> <20071217215658.GA4782@elte.hu>
In-Reply-To: <20071217215658.GA4782@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17-12-07 22:56, Ingo Molnar wrote:

> * Rene Herman <rene.herman@gmail.com> wrote:
> 
>>>> Signed-off-by: Rene Herman <rene.herman@gmail.com>
>>> hm, i see this as a step backwards from the pretty flexible patch 
>>> that David already tested. (and which also passed a few hundred 
>>> bootup tests on my x86 test-grid)
>> Please see Alan's comment that udelay (and none) shouldn't yet be 
>> provided as a choice. It opens race windows in drivers even when it 
>> works in practice on most setups. The version with "udelay" and "none" 
>> is not minimal, not low risk and certainly not .24 material.
> 
> huh? By default we still use port 0x80. Any udelay is non-default and 
> needs the user to explicitly switch to it.  But it enables us to debug
> any suspected drivers by asking testers to: "please try this driver with 
> io_delay=udelay, does it still work fine?". So those extra options are 
> quite sensible. If you have any real technical arguments against that 
> then please let us know.

Ingo, have lots of fun playing with yourself, but remove my sign off from 
anything with the udelay and none methods.

Rene.
