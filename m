Return-Path: <linux-kernel-owner+w=401wt.eu-S1754319AbZLAQqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbZLAQqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbZLAQqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:46:16 -0500
Received: from mail.vyatta.com ([76.74.103.46]:51336 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839AbZLAQqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:46:15 -0500
Date: Tue, 1 Dec 2009 08:45:50 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/block/floppy.c: stylistic cleanups
Message-ID: <20091201084550.586a728b@nehalam>
In-Reply-To: <1259640820.13592.37.camel@Joe-Laptop.home>
References: <1259001504.16503.79.camel@Joe-Laptop.home>
	<20091123.104130.117837098.davem@davemloft.net>
	<1259528449.29779.194.camel@Joe-Laptop.home>
	<20091129.165557.84377714.davem@davemloft.net>
	<20091130092837.4998f961@nehalam>
	<1259640820.13592.37.camel@Joe-Laptop.home>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009 20:13:40 -0800
Joe Perches <joe@perches.com> wrote:

> On Mon, 2009-11-30 at 09:28 -0800, Stephen Hemminger wrote:
> > Rather than playing with the dangling operator format which seems to be a coding
> > style that only David cares about. Why not go through and fix the really ugly old
> > drivers that need it. For a good horror experience, go look at the floppy driver.
> 
> Just for you Stephen, here's a cleaned up version.
> Now to see if it gets applied, which I rather doubt.
> 
> Changes:
> 
> Removed macro definitions and uses of
> 	IN, OUT, LAST_OUT, CLEARSTRUCT, and CHECK_RESET
> Used C99 initializers
> Removed assigns from if statements
> Converted printks without KERN_ levels to pr_info and pr_cont
> Removed unnecessary braces
> Used print_hex_dump
> Moved leading logical tests to end of previous line
> Surrounded still ugly CALL and ECALL macro with do {} while (0)
> 
> Checkpatch complaints before:
> total: 393 errors, 132 warnings, 4647 lines checked
> 
> after:
> total: 1 errors, 11 warnings, 5352 lines checked
> 
> Compile tested only, x86 allyesconfig
> 
> Signed-off-by: Joe Perches <joe@perches.com>

I have a fix (to get rid of Buffer I/O error when testing for drive present),
so I'll put your cleanup in first.


-- 
