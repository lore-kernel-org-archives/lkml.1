Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbXEABkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbXEABkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 21:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbXEABkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 21:40:35 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44517 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397AbXEABke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 21:40:34 -0400
Message-ID: <46369A8F.1050809@garzik.org>
Date: Mon, 30 Apr 2007 21:40:31 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
References: <463698D5.20102@zytor.com>
In-Reply-To: <463698D5.20102@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Hi all,
> 
> I'm rewriting the i386 setup code in C, instead of assembly, and before
> I spend a very large amount of time translating all the various
> card-specific probes, I want to ask the following question...
> 
> Does *anyone* care about these anymore?
> 
> All of these are specific to cards from a very long time ago.  I am
> currently planning to retain the VESA-related code, and the standard
> video modes, but I'd like to avoid the card-specific stuff, especially
> since I have absolutely zero ability to test any of testing them (with
> the possible sole exception of the cirrus5 code, which is emulated by qemu.)

Do you mean the SVGA chip-specific code, or additionally you are ripping 
out CGA and EGA support?

Out of curiosity what C compiler will you use?

	Jeff


