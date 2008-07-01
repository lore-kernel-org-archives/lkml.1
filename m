Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbYGAL2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbYGAL2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 07:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbYGAL2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 07:28:08 -0400
Received: from bu3sch.de ([62.75.166.246]:46660 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbYGAL2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 07:28:08 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH RFC] x86: Add user configurable GPIO-lib support
Date: Tue, 1 Jul 2008 13:27:23 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel <linux-kernel@vger.kernel.org>,
       florian.fainelli@telecomint.eu,
       the arch/x86 maintainers <x86@kernel.org>
References: <200807011249.40551.mb@bu3sch.de> <200807011313.40598.mb@bu3sch.de> <20080701111918.GA11809@elte.hu>
In-Reply-To: <20080701111918.GA11809@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807011327.23929.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 July 2008 13:19:18 Ingo Molnar wrote:
> 
> * Michael Buesch <mb@bu3sch.de> wrote:
> 
> > > ... and thus perhaps your GPIO_USERSELECTION patch should move into 
> > > drivers/ and be generally accessible, not special to x86?
> > 
> > Yes I'd really like to move it there, too. But currently that clashes 
> > with architectures like MIPS, some PPC flavours and probably others 
> > that implement their own GPIO API. We should have an 
> > ARCH_IMPLEMENT_GPIO or whatever, but currently we don't seem to have 
> > that.
> > 
> > So well. If it's desired to put the user selection into drivers/gpio 
> > (which I'd really prefer), I can try to make a patch that adds 
> > ARCH_IMPLEMENT_GPIO to every arch that implements their own GPIO API 
> > and make GPIO_USERSELECTION depend on !ARCH_IMPLEMENT_GPIO.
> 
> or we could try it the other way around: stick 
> ARCH_ALLOWS_TRULY_GENERAL_PURPOSE_INPUT_OUTPUT (note: please use a 
> better name ;-) into x86, add the user text to drivers/ and let other 
> architectures enable it too?
> 
> That way your commits would still be pretty focused (you'd avoid having 
> to touch a lot of architectures) and it would still work all across the 
> spectrum.
> 
> hm?

Yeah great idea :)
I'll make a patch later.

-- 
Greetings Michael.
