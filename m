Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbZDTBA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbZDTBA7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 21:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbZDTBAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 21:00:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211AbZDTBAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 21:00:48 -0400
Date: Sun, 19 Apr 2009 17:52:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: Paul Mundt <lethal@linux-sh.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT] kbuild
In-Reply-To: <20090419234501.GA6475@uranus.ravnborg.org>
Message-ID: <alpine.LFD.2.00.0904191745390.2199@localhost.localdomain>
References: <20090419092555.GA19213@uranus.ravnborg.org> <20090419223959.GB12054@linux-sh.org> <20090419234501.GA6475@uranus.ravnborg.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Apr 2009, Sam Ravnborg wrote:
> 
> You will soon see a path from me where I fix sh too.

Can we do a global 'sed s:asm/asm-offsets.h:generated/asm-offsets.h:g' 
thing too? And then get rid of the include/asm symlink?

That asm-offsets.h mess is scary. I don't quite know why kvm on ia64 seems 
to do it's own asm-offsets.h file, for example. And arch/blackfin/Makefile 
mentions arch/$(ARCH)/include/asm/asm-offsets.h (but does it actually do 
one?).

		Linus
