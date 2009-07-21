Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbZGUQRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbZGUQRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZGUQRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:17:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37872 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751850AbZGUQRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:17:06 -0400
Date: Tue, 21 Jul 2009 17:18:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Daniel Mack <daniel@caiaq.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] [usb-serial] fix Ooops on uplug
Message-ID: <20090721171811.278a2c62@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0907211205420.2724-100000@iolanthe.rowland.org>
References: <20090721170055.10cce812@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.0907211205420.2724-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009 12:11:39 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Tue, 21 Jul 2009, Alan Cox wrote:
> 
> > > The problem is that freed resources are accessed, and that can lead to
> > > any kind of strange kernel faults from crashing to other subsequent
> > > errors.
> > > 
> > > Did you try my patch?
> 
> No.
> 
> > We've already established your patch is wrong. So trying it isn't at all
> > helpful.
> 
> I'll take your word for it.  It will take some time to figure out 
> exactly which buffers are getting used after they are freed, although 
> the most likely is the usb_serial_port structure itself.
> 
> Let you know what I find...

On the tty side if you look in tty_io.c there is a define

TTY_DEBUG_HANGUP

which exists especially for these sorts of events..

