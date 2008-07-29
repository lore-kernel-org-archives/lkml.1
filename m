Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbYG2VhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbYG2VhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 17:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbYG2VhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 17:37:09 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:10084 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbYG2VhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 17:37:08 -0400
Date: Tue, 29 Jul 2008 23:37:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux v2.6.27-rc1
Message-ID: <20080729213746.GA22548@uranus.ravnborg.org>
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 08:23:21PM -0700, Linus Torvalds wrote:

> The build system also got updated to 
> allow moving the architecture include files ("include/asm-xyz") into the 
> architecture subdirectories ("arch/xyz/include/asm"), and sparc seems to 
> have taken advantage of that already.

Most architectures are easy to convert. But those that uses
symlinks to select between different platforms etc needs a bit more
care if we shall get rid of all symlinks.

Paul already fixed up sh and sent you a pull request.
I have something ready for arm (not yet posted).
And I sent Harvaard a small script that can fix avr32 when arm is done.
cris looks similar and I can take care too.

The rest that does not use additiona symlinks are in general much simpler.

Kyle already fixed up parisc (simple).
x86 is simple - only a small patch needed to arch/x86/Makefile.
I have not dared looking at um.

But will you accept this stuff now or will we have to wait until
next merge window?
Now is a good time as development just started for next kernel.
And testing is simple - does it build?

It will come in via arch maintainers but I will assist.

	Sam
