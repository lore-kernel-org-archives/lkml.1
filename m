Return-Path: <linux-kernel-owner+w=401wt.eu-S934355AbYEUCUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934355AbYEUCUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 22:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760428AbYEUCUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 22:20:17 -0400
Received: from [198.99.130.12] ([198.99.130.12]:44846 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756417AbYEUCUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 22:20:14 -0400
Date: Tue, 20 May 2008 22:15:02 -0400
From: Jeff Dike <jdike@addtoit.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Tom Spink <tspink@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: UML fails to locate address space
Message-ID: <20080521021502.GB16212@c2.user-mode-linux.org>
References: <7b9198260805200408k1d6b70a8xc7e4c24106e5020f@mail.gmail.com> <20080520135238.GB6990@c2.user-mode-linux.org> <Pine.LNX.4.61.0805201117540.12360@chaos.analogic.com> <20080520173503.GA10811@c2.user-mode-linux.org> <Pine.LNX.4.61.0805201751500.13532@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0805201751500.13532@chaos.analogic.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 05:54:34PM -0400, linux-os (Dick Johnson) wrote:
> Okay, then instead of putting a NULL in the "hint" to mmap() try
> something else (0x1000?). That may help.

You don't seem to have followed the thread.  For UML, the address
isn't a hint - it's a requirement.  Tossing random numbers into your
code until a particular test works isn't really the way to go.  In
this case, we are looking at mmap_min_addr being set at 0x10000, but
which may be set to 0x20000 someplace else.

      	     	    Jeff

-- 
Work email - jdike at linux dot intel dot com
