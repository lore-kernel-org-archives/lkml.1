Return-Path: <linux-kernel-owner+w=401wt.eu-S932810AbXBXQFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810AbXBXQFz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 11:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932838AbXBXQFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 11:05:55 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:41446 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810AbXBXQFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 11:05:54 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 24 Feb 2007 10:59:42 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Oleg Verych <olecom@flower.upol.cz>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ioctls.h (Re: [PATCH][RFC] Make asm-generic/ioctl.h extensible
 by adding conditionals.)
In-Reply-To: <E1HKwCy-0005OM-FW@flower>
Message-ID: <Pine.LNX.4.64.0702241058140.19099@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0702240641520.15087@CPE00045a9c397f-CM001225dbafb6>
 <E1HKwCy-0005OM-FW@flower>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Feb 2007, Oleg Verych wrote:

> > From: "Robert P. J. Day"
> > Newsgroups: gmane.linux.kernel
> > Subject: [PATCH][RFC] Make asm-generic/ioctl.h extensible by adding conditionals.
> > Date: Sat, 24 Feb 2007 06:45:20 -0500 (EST)
>
> >   as a followup to my earlier post, is it worth making this change
> > to allow at least a couple arch-specific ioctl.h files to be
> > massively simplified?
>
> And i wonder, why there is no generic ioctls.h, hm?

beats me, but it seems that there are a *number* of arch-specific
header files that could be treated this way -- a single generic file,
allowing the small number of customizations that seem to be necessary
across all architectures.

but i figured i'd start with ioctl.h first and see where it went from
there.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
