Return-Path: <linux-kernel-owner+w=401wt.eu-S932359AbXCRPmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbXCRPmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 11:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932260AbXCRPmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 11:42:47 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:43789 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbXCRPmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 11:42:46 -0400
X-Originating-Ip: 74.109.98.130
Date: Sun, 18 Mar 2007 11:38:38 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Andi Kleen <andi@firstfloor.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] Delete obsolete RAW driver feature.
In-Reply-To: <p73y7lu5yt6.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0703181138050.15352@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0703180754060.6605@CPE00045a9c397f-CM001225dbafb6>
 <p73y7lu5yt6.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Mar 2007, Andi Kleen wrote:

> "Robert P. J. Day" <rpjday@mindspring.com> writes:
>
> > Delete the allegedly obsolete raw driver feature, which has been
> > marked for death since 2005.
>
> I think it would be better to replace it with a wrapper that forces
> O_DIRECT and opens the underlying block device.  I suspect just
> dropping it will break many people's database setups, which is not
> nice.  Widely used admin interfaces should be only broken when there
> is a very good reason and just "there is a better way now" doesn't
> seem quite strong enough.

ok, i'll leave that in the hands of those higher up the food chain.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
