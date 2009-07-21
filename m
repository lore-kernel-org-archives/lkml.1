Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbZGUQLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbZGUQLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbZGUQLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:11:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51396 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755238AbZGUQLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:11:39 -0400
Date: Tue, 21 Jul 2009 12:11:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Daniel Mack <daniel@caiaq.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] [usb-serial] fix Ooops on uplug
In-Reply-To: <20090721170055.10cce812@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0907211205420.2724-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009, Alan Cox wrote:

> > The problem is that freed resources are accessed, and that can lead to
> > any kind of strange kernel faults from crashing to other subsequent
> > errors.
> > 
> > Did you try my patch?

No.

> We've already established your patch is wrong. So trying it isn't at all
> helpful.

I'll take your word for it.  It will take some time to figure out 
exactly which buffers are getting used after they are freed, although 
the most likely is the usb_serial_port structure itself.

Let you know what I find...

Alan Stern


