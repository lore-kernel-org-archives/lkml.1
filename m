Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbYCCGVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbYCCGVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 01:21:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYCCGU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 01:20:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43560 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbYCCGU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 01:20:56 -0500
Date: Mon, 3 Mar 2008 06:20:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 1/2] Add C99-style constructor macros for specific-sized integers
Message-ID: <20080303062007.GY27894@ZenIV.linux.org.uk>
References: <4a8566f54ff84f498c5c0c0340076c296b1840e6@tazenda.hos.anvin.org> <20080303023851.GF24386@parisc-linux.org> <47CB81EA.8070802@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CB81EA.8070802@zytor.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2008 at 08:43:22PM -0800, H. Peter Anvin wrote:
> >>+#define S64_C(x) x ## LL
> >>+#define U64_C(x) x ## ULL
> >
> >but can't we use the latter for all arches?
> >
> 
> You really don't want to, as the whole point is that you want it to 
> match what u64/s64 is defined as, in order to avoid spurious warnings.

Excuse me, in which contexts?  Where does replacement of explicitly long
constant with explicitly long long one generate warnings on a host that has
range(long) equal to range(long long)?
