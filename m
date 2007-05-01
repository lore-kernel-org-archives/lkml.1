Return-Path: <linux-kernel-owner+w=401wt.eu-S1945980AbXEAVxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945980AbXEAVxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945993AbXEAVxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:53:11 -0400
Received: from terminus.zytor.com ([192.83.249.54]:45727 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945980AbXEAVxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:53:08 -0400
Message-ID: <4637B6B5.5060502@zytor.com>
Date: Tue, 01 May 2007 14:52:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Rene Herman <rene.herman@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
References: <463698D5.20102@zytor.com> <alpine.LFD.0.98.0704301940320.3808@woody.linux-foundation.org> <4637A3F6.70508@gmail.com> <alpine.LFD.0.98.0705011433050.3808@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705011433050.3808@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> And yes, I'm literally talking about the *text* modes. Not all of us want 
> to have fbcon built in - I prefer my text-mode lean and mean and fast as 
> hell, and if I want a frame buffer, I'll take X11, thank you very much.
> 

I use framebuffer console pretty much for one purpose -- it sucks less
memory bandwidth when you're stuck with a UMA configuration.  Text modes
require random access to the font buffer, which means it hogs the DRAM
pretty badly, unless the chipset designer decided to burn an 8K SRAM,
which is still a pretty pricey hunk of chip real estate.

	-hpa
