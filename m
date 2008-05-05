Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbYEEPtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbYEEPtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 11:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYEEPtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 11:49:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401AbYEEPte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 11:49:34 -0400
Date: Mon, 5 May 2008 08:48:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@codemonkey.org.uk>
cc: Jan Engelhardt <jengelh@medozas.de>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: changeset: Make forced module loading optional
In-Reply-To: <20080505153230.GA25704@codemonkey.org.uk>
Message-ID: <alpine.LFD.1.10.0805050842050.32269@woody.linux-foundation.org>
References: <200805051455.02723.rusty@rustcorp.com.au> <alpine.LFD.1.10.0805042159230.32269@woody.linux-foundation.org> <alpine.LNX.1.10.0805050835450.11757@fbirervta.pbzchgretzou.qr> <20080505153230.GA25704@codemonkey.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 May 2008, Dave Jones wrote:
> 
> For Fedora (and many other distros), you can replace the last three lines with 'make install'
> It'll do everything. Construct the initrd. Install it & the vmlinuz, point grub.conf at it. etc.

You guys aren't even listening, are you?

None of the above even *works* if you don't have modules enabled (which I 
mostly don't).

This bug reared its ugly head exactly because I normally don't do modules 
AT ALL, but had to have modules enabled on some of my machines due to 
Intel wireless legacy reasons.

Anyway, can we please agree to not beat a dead horse. If you cannot accept 
the fact that I want to just replace the kernel, then please don't even 
bother Cc'ing me in the discussion. Ok? Because if you cannot respect my 
choices, I sure as hell am not interested in hearing you blather about how 
I need to change how I use my kernel. You diss me, I diss you.

End of discussion.

		Linus
