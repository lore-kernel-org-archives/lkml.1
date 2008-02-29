Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbYB2Far@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbYB2Far (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 00:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbYB2Fag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 00:30:36 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:40775 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbYB2Fag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 00:30:36 -0500
Date: Thu, 28 Feb 2008 22:30:14 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org
Subject: Re: [PATCH 11/12] Generic semaphore implementation
Message-ID: <20080229053014.GA19198@parisc-linux.org>
References: <1204180441-8540-5-git-send-email-matthew@wil.cx> <1204180441-8540-6-git-send-email-matthew@wil.cx> <1204180441-8540-7-git-send-email-matthew@wil.cx> <1204180441-8540-8-git-send-email-matthew@wil.cx> <1204180441-8540-9-git-send-email-matthew@wil.cx> <1204180441-8540-10-git-send-email-matthew@wil.cx> <1204180441-8540-11-git-send-email-matthew@wil.cx> <20080228071822.GA13571@elte.hu> <20080229003954.GA525@parisc-linux.org> <20080228174349.1da254bd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228174349.1da254bd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 05:43:49PM -0800, Andrew Morton wrote:
> err, we'd better tell the arch maintainers than we just deleted all their
> sempahore code.
     ^^  I'm so glad it's not just me who makes that typo.  I actually
grepped for it before sending the patches out.

I did already send it to linux-arch back in January or so.  But a
reminder won't hurt.

> yummy summary:
> 
>  254 files changed, 386 insertions(+), 7827 deletions(-)

Yeah, that's quite attractive ;-)

> Yes, let's get this into linux-next if poss please.  If mainline later
> breaks for some architecture, well, we did our best..

It _should_ only be build breakage.  I guess we'll see.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
