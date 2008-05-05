Return-Path: <linux-kernel-owner+w=401wt.eu-S1758838AbYEEOiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbYEEOiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756139AbYEEOij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:38:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756016AbYEEOii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:38:38 -0400
Date: Mon, 5 May 2008 07:37:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Engelhardt <jengelh@medozas.de>
cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Jon Masters <jonathan@jonmasters.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: changeset: Make forced module loading optional
In-Reply-To: <alpine.LNX.1.10.0805050835450.11757@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LFD.1.10.0805050735150.32269@woody.linux-foundation.org>
References: <200805051455.02723.rusty@rustcorp.com.au> <alpine.LFD.1.10.0805042159230.32269@woody.linux-foundation.org> <alpine.LNX.1.10.0805050835450.11757@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 May 2008, Jan Engelhardt wrote:
> 
> That's not good procedure IMO. You always want to keep a known good
> (=booting) kernel, and the distro-provided one might just be that.

Yes, I've always had a known-good fallback. So I actually do duplicate the 
lines and leave unchanged versions in /etc/grub.conf for when things go 
wrong.

But my point is, I really want to change just the kernel. I don't want to 
care what the initrd does, and I don't want to build my own. It's all 
"user space" to me - and thus beneath my notice.

And the module loading bug was just that - a kernel bug. 

			Linus
