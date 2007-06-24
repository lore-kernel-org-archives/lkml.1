Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbXFXWQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbXFXWQP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 18:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbXFXWP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 18:15:59 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:59021 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbXFXWP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 18:15:58 -0400
X-Originating-Ip: 74.102.207.204
Date: Sun, 24 Jun 2007 18:12:11 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] Update the alignment for 4K stacks.
In-Reply-To: <20070624123906.5e1c4b2a.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706241812020.546@localhost.localdomain>
References: <Pine.LNX.4.64.0706241518590.24337@localhost.localdomain>
 <20070624123906.5e1c4b2a.akpm@linux-foundation.org>
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

On Sun, 24 Jun 2007, Andrew Morton wrote:

> On Sun, 24 Jun 2007 15:21:37 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:
>
> >  arch/i386/kernel/irq.c |    8 ++------
> >  arch/sh/kernel/irq.c   |    8 ++------
>
> These two files are maintained by different developers who run
> separate development trees.  Please do not try to alter them
> both in the same patch.

ok, i'll split them.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
