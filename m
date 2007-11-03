Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbXKCQ1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbXKCQ1Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 12:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbXKCQ1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 12:27:01 -0400
Received: from waste.org ([66.93.16.53]:43928 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006AbXKCQ1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 12:27:00 -0400
Date: Sat, 3 Nov 2007 11:26:40 -0500
From: Matt Mackall <mpm@selenic.com>
To: Bo Brant?n <bosse@acc.umu.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: x86_64 ten times slower than i386
Message-ID: <20071103162640.GS17536@waste.org>
References: <Pine.A41.4.64.0711031329490.397338@stalin.acc.umu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.A41.4.64.0711031329490.397338@stalin.acc.umu.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2007 at 01:31:49PM +0100, Bo Brant?n wrote:
> 
> Hello,
> 
> I tryed different linux distributions on a computer with an Intel Core 2 
> Quad and I noticed that the 64-bit versions was at least 10 times slower 
> than the 32-bit versions, to boot the system took over 20 minutes in 64-bit 
> mode and then even scrolling text at the command prompt felt slow, however 
> Vista 64 boots as fast as Vista 32 on the same computer. So I would like to 
> ask if this is a known problem or if there is some simple misstake I can 
> have done.
> 
> I used live cd's from gentoo and ubunto and at least ubuntu has a rather 
> new kernel, also dmesg doesn't show anything strange, for example is the 
> bogomips figure the same as when booting in 32-bit mode.

This is typically due to a problem with the setup of your MTRRs. Try
booting with mem=nnnM where nnn is some number smaller than your
actual amount of memory.

-- 
Mathematics is the supreme nostalgia of our time.
