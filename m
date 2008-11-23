Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbYKWSrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbYKWSrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 13:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYKWSrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 13:47:14 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:23902 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbYKWSrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 13:47:13 -0500
Date: Sun, 23 Nov 2008 19:46:52 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86: introduce ENTRY(KPROBE)_X86  assembly helpers to catch unbalanced declaration
Message-ID: <20081123184652.GB419@mailshack.com>
References: <20081123165711.GA12710@localhost> <20081123175125.GA32472@uranus.ravnborg.org> <20081123175846.GF12710@localhost> <20081123181248.GA338@uranus.ravnborg.org> <20081123182103.GH12710@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123182103.GH12710@localhost>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Sun, 23 Nov 2008 19:46:56 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.35; VDF: 7.1.0.123; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 09:21:03PM +0300, Cyrill Gorcunov wrote:
> [Sam Ravnborg - Sun, Nov 23, 2008 at 07:12:48PM +0100]
> ...
> | > 
> | > I don't have -next tree on my laptop, neither cross-compile tools but
> | > if someone could test it -- it would be great. But I used gas macros
> | > here -- i doubt other architectures has the same syntax. At least
> | > PDP-11 would beat us with ';' symbol :)
> | 
> | If we include this in any of the 100+ trees that Stephen sucks
> | into -next we will get it tried out.
> | 
> | Ingo has so and so does others so getting it into -next
> | is rather easy. Then the automated builds will tell of if
> | it fails on any of the toolchains used there.
> | 
> | 	Sam
> | 
> 
> Sam, to be clear, you mean that I could put this stuff into general
> include/linux/linkage.h with general names as ENTRY/END and the same
> for KPROBE so it could be merged into -next tree for testing? If yes,
> that as I said there will be a lot of errors so build will stuck in
> a moment 'cause of unbalanced ENTRY. Not sure if it's a good idea :)

Hi Cyrill,

Aborting might be a bit to heavyhanded for -next. Maybe you should
prepare a version that only gives a warning for the first problem
it encounters per file? That would be fine in -next.

Greetings,
	Alexander

> 		- Cyrill -
