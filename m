Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbYB2Fcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbYB2Fcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 00:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbYB2Fce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 00:32:34 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:40780 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbYB2Fcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 00:32:33 -0500
Date: Thu, 28 Feb 2008 22:32:32 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-next@vger.kernel.org,
       Linus <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH 11/12] Generic semaphore implementation
Message-ID: <20080229053232.GB19198@parisc-linux.org>
References: <1204180441-8540-6-git-send-email-matthew@wil.cx> <1204180441-8540-7-git-send-email-matthew@wil.cx> <1204180441-8540-8-git-send-email-matthew@wil.cx> <1204180441-8540-9-git-send-email-matthew@wil.cx> <1204180441-8540-10-git-send-email-matthew@wil.cx> <1204180441-8540-11-git-send-email-matthew@wil.cx> <20080228071822.GA13571@elte.hu> <20080229003954.GA525@parisc-linux.org> <20080229130019.3ede8053.sfr@canb.auug.org.au> <20080228181054.dddcf559.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228181054.dddcf559.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 06:10:54PM -0800, Andrew Morton wrote:
> Most of the conflicts will be due to all the
> 
> -#include <asm/semaphore.h>
> +#include <linux/semaphore.h>
> 
> but they're all optional anyway, because include/asm-*/semaphore.h is
> 
> #include <linux/semaphore.h>
> 
> so either a) you just ignore all those conflicts or b) we ask Willy to
> remove all that stuff and we can trickle it in via subsystems later.

Yeah, we can trickle that in later.  Fine by me.

I think rather more conflict is likely with the 105 files where I just
removed the asm/semaphore.h include.  I'd like it if we could get Linus
to merge those at this stage.  Since it passes an x86 allmodconfig
build, I'd like to think the breakage would be minimal.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
