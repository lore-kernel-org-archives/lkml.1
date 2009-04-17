Return-Path: <linux-kernel-owner+w=401wt.eu-S1758630AbZDQRo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630AbZDQRo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 13:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbZDQRop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 13:44:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758961AbZDQRoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 13:44:44 -0400
Date: Fri, 17 Apr 2009 10:37:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: takata@linux-m32r.org
cc: Sam Ravnborg <sam@ravnborg.org>, Christoph Hellwig <hch@lst.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] m32r: move include/asm-m32r to
 arch/m32r/include/asm
In-Reply-To: <swfmyag9fx8.wl%takata.hirokazu@renesas.com>
Message-ID: <alpine.LFD.2.00.0904171034140.4042@localhost.localdomain>
References: <20090416150707.GA941@lst.de> <20090416164050.GB4850@uranus.ravnborg.org> <swfmyag9fx8.wl%takata.hirokazu@renesas.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Apr 2009, takata@linux-m32r.org wrote:
> 
> I have moved asm-m32r headers and build-checked.
> 
> Please pull from the following m32r git tree:
>   git://www.linux-m32r.org/git/takata/linux-2.6_dev.git for-linus

Ok, pulled.

I also removed the last remnants of asm-h8300 (a file that was added after 
the more of everything else) and asm-arm (a stale .gitignore file).

So now the only thing left is the build-time include/asm-$(ARCH) 
generation usually for just that "<asm/asm-offsets.h> file.

Oh, and the "asm -> asm-$(ARCH)" symlink that the asm-offsets.h thing 
brings with it.

There may be other auto-generated cases, of course, asm-offsets.h is the 
only one I happen to see during my regular x86-64 build.

		Linus
