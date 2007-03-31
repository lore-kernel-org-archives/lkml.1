Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbXCaKn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbXCaKn4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 06:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbXCaKn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 06:43:56 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:55256 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbXCaKnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 06:43:55 -0400
X-Originating-Ip: 74.109.98.130
Date: Sat, 31 Mar 2007 06:43:13 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Andreas Schwab <schwab@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: updated list of "dead" Makefile CONFIG_ variables
In-Reply-To: <je1wj51yyi.fsf@sykes.suse.de>
Message-ID: <Pine.LNX.4.64.0703310642360.1381@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0703310552560.26371@CPE00045a9c397f-CM001225dbafb6>
 <je1wj51yyi.fsf@sykes.suse.de>
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

On Sat, 31 Mar 2007, Andreas Schwab wrote:

> "Robert P. J. Day" <rpjday@mindspring.com> writes:
>
> > ===== MACHINE =====
> > ./arch/ppc/boot/simple/Makefile:# zimage-$(CONFIG_MACHINE) and zimagerd-$(CONFIG_MACHINE) to the target
> > ./arch/ppc/boot/simple/Makefile:# that produces the desired image and they must set end-$(CONFIG_MACHINE)
> > ./arch/ppc/boot/simple/Makefile:# than 'zImage.elf', set end-$(CONFIG_MACHINE) to be the suffix used for
> > ./arch/ppc/boot/simple/Makefile:# set entrypoint-$(CONFIG_MACHINE) to the location which the image should be
> > ./arch/ppc/boot/simple/Makefile:# loaded at.  The optimal setting for entrypoint-$(CONFIG_MACHINE) is the link
> > ./arch/ppc/boot/simple/Makefile:# misc-$(CONFIG_MACHINE) variable.
>
> That looks like a meta variable.  It's only a comment anyway.
>
> Andreas.

whoops, my bad, i totally missed that.  ack.  time to refine the
script, methinks.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
