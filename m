Return-Path: <linux-kernel-owner+w=401wt.eu-S1758510AbYCCCjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbYCCCjY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 21:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbYCCCjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 21:39:14 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:55563 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792AbYCCCjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 21:39:13 -0500
Date: Sun, 2 Mar 2008 19:38:52 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 1/2] Add C99-style constructor macros for specific-sized integers
Message-ID: <20080303023851.GF24386@parisc-linux.org>
References: <4a8566f54ff84f498c5c0c0340076c296b1840e6@tazenda.hos.anvin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a8566f54ff84f498c5c0c0340076c296b1840e6@tazenda.hos.anvin.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2008 at 04:09:51PM -0800, H. Peter Anvin wrote:
> first place.  C99 has macros of the form [U]INT#_C() to construct
> numbers of an arbitrary size; this patch creates analogous macros for
> the kernel s# and u# types.

Why put this in asm/types.h instead of, say, linux/types.h?

I appreciate you have:

> +#define S64_C(x) x ## L
> +#define U64_C(x) x ## UL

and:

> +#define S64_C(x) x ## LL
> +#define U64_C(x) x ## ULL

but can't we use the latter for all arches?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
