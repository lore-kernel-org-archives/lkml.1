Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbYARKOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbYARKOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:14:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbYARKN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:13:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60719 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbYARKN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:13:56 -0500
Date: Fri, 18 Jan 2008 08:13:39 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] fix wrong sized spinlock flags argument
Message-ID: <20080118081339.3da1dceb@areia>
In-Reply-To: <1200614706.18731.170.camel@imap.mvista.com>
References: <20080117205205.878723737@mvista.com>
	<alpine.LFD.1.00.0801171542390.2957@woody.linux-foundation.org>
	<1200614706.18731.170.camel@imap.mvista.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 16:05:06 -0800
Daniel Walker <dwalker@mvista.com> wrote:

> 
> On Thu, 2008-01-17 at 15:48 -0800, Linus Torvalds wrote:
> > Applied.
> > 
> > However, the patch itself didn't apply cleanly, because in my souce tree, 
> > these two lines are in a different order:
> > 
> > On Thu, 17 Jan 2008, Daniel Walker wrote:
> > >  
> > >  	pci_set_power_state(pci_dev, PCI_D0);
> > >  	pci_restore_state(pci_dev);
> > 
> > but I actually think your order is the *correct* one (because I'm not at 
> > all sure that config space writes are even guaranteed to make a difference 
> > when in D3cold).
> 
> I was actually using 2.6.24-rc8-mm1 . The code looked similar enough,
> but I must have overlooked the fact that the lines above got switched..

There were lots of change on saa7134, including the implementation of S1/S3.
I'll run some tests here fixing the order and apply Daniel's patch.

Cheers,
Mauro
