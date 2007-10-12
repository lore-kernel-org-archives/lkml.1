Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbXJLMWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbXJLMWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 08:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbXJLMWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 08:22:46 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:40237 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbXJLMWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 08:22:45 -0400
X-Originating-Ip: 99.236.101.138
Date: Fri, 12 Oct 2007 08:18:30 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what is the rationale for "TAINT_USER"?
In-Reply-To: <Pine.LNX.4.64.0710120801380.20049@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0710120814050.21625@localhost.localdomain>
References: <Pine.LNX.4.64.0710120801380.20049@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007, Robert P. J. Day wrote:

>
>   i can see what the theoretical purpose for it is here:
>
> http://kerneltrap.org/node/6656
>
> but it's not clear how it can possibly be set from userland given
> that:
>
> $ grep -r TAINT_USER *
> include/linux/kernel.h:#define TAINT_USER                       (1<<6)
> kernel/panic.c:                 tainted & TAINT_USER ? 'U' : ' ',
> $
>
>   am i missing something screamingly obvious?

whoops, never mind -- if i read correctly, that particular flag bit
must be set *explicitly* when writing to /proc/sys/kernel/tainted.  i
originally thought it would be set by kernel code simply by the act of
writing to /proc/sys/kernel/tainted, and i couldn't see where that was
happening.  carry on.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
