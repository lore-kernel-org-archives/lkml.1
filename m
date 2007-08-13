Return-Path: <linux-kernel-owner+w=401wt.eu-S1032011AbXHMRhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032011AbXHMRhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765114AbXHMRde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:33:34 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:60225 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S943002AbXHMRdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:33:31 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 13 Aug 2007 13:26:51 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Roland Dreier <rdreier@cisco.com>
cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, surya.prabhakar@wipro.com,
       mingo@redhat.com, yaku@css1.kbnes.nec.co.jp,
       kisimoto@css1.kbnes.nec.co.jp, zab@redhat.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [KJ] replacing kmalloc with kzalloc in io_apic.c
In-Reply-To: <aday7gf8hw4.fsf@cisco.com>
Message-ID: <Pine.LNX.4.64.0708131326330.8900@localhost.localdomain>
References: <1186993881.3175.15.camel@bluegenie> <200708131518.20580.m.kozlowski@tuxland.pl>
 <Pine.LNX.4.64.0708131153190.4382@localhost.localdomain> <aday7gf8hw4.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.541, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	SARE_SUB_OBFU_Z 0.26)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007, Roland Dreier wrote:

>  > from my days submitting numerous patches of this type, i can recall
>  > that in cases like the above, it's a judgment call -- use kzalloc to
>  > get the zeroing, or use kcalloc to get the array-flavoured behaviour.
>  > what a shame you can't have both at the same time.
>
> kcalloc() zeros memory just like standard calloc() in userspace.
>
> As <linux/slab.h> says:
>
>  * kcalloc - allocate memory for an array. The memory is set to zero.

oops.  quite right, my bad.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
