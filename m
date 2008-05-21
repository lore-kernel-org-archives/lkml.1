Return-Path: <linux-kernel-owner+w=401wt.eu-S1764527AbYEUXW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764527AbYEUXW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 19:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755710AbYEUXWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 19:22:16 -0400
Received: from ozlabs.org ([203.10.76.45]:52743 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230AbYEUXWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 19:22:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18484.44691.477859.334222@cargo.ozlabs.ibm.com>
Date: Thu, 22 May 2008 09:21:55 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Moving include/asm-* [was: Re: Moving sound/* to drivers/ ?]
In-Reply-To: <alpine.LFD.1.10.0805211431370.3081@woody.linux-foundation.org>
References: <s5hzlqjz74d.wl%tiwai@suse.de>
	<alpine.LFD.1.10.0805211431370.3081@woody.linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:

> Me personally, I've been more irritated by include/asm-xyz vs arch/xyz. It 
> would be so nice if all the arch-specific changes woudl always show up 
> under arch/ (both from a statistics standpoint, and just because then a 
> diffstat really shows arch-specific stuff really obviously, and sorts all 
> the arch-specific stuff together).

We could git mv include/asm-xyz arch/xyz/asm and then arrange to pass
-Iarch/$(ARCH) to gcc.  The only downside is that "asm" is a slightly
strange name for a directory of include files, but I assume we don't
want to have to change all the #include <asm/blah.h> lines in all the
*.c files.

Paul.
