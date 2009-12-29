Return-Path: <linux-kernel-owner+w=401wt.eu-S1752112AbZL2UNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbZL2UNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 15:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZL2UNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 15:13:49 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:50413 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbZL2UNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 15:13:48 -0500
Date: Tue, 29 Dec 2009 15:13:14 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Jeff Garzik <jeff@garzik.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what's the purpose of MAXHOSTNAMELEN?
In-Reply-To: <4B3A5B15.5060807@garzik.org>
Message-ID: <alpine.LFD.2.00.0912291507490.2610@localhost>
References: <alpine.LFD.2.00.0912291416230.4967@localhost> <4B3A5B15.5060807@garzik.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Dec 2009, Jeff Garzik wrote:
... snip ..

> >    so lots of people define it but no one uses it.  it *is*
> > exported to user space in /usr/include/asm/param.h, but i still
> > have no idea what it's for in user space.  obsolete?
>
> According to RFC 1034, "Each node has a label, which is zero to 63
> octets in length"
>
> What is it used for in userspace, and why is it export from the
> kernel?  Good question...

  it's not clear what value that macro has in user space since (as
i've always understood it) the point of exporting a macro like that to
user space is so that user space apps can *agree* with kernel code
that employs the same macro.

  but if absolutely *nothing* in the kernel uses that macro, then
there's nothing for user space to "agree" with.  in other words, that
macro cannot *possibly* have any meaningful value in user space. does
that make sense?

  my reaction at this point is to simply remove that macro definition
from include/asm-generic/param.h.  anything in user space that's using
that macro is simply using a macro with a completely arbitrary value.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
