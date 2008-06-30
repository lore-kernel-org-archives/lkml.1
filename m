Return-Path: <linux-kernel-owner+w=401wt.eu-S932612AbYF3V3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612AbYF3V3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761083AbYF3V3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:29:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37413 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760270AbYF3V3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:29:08 -0400
Date: Mon, 30 Jun 2008 17:29:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Stefan Becker <Stefan.Becker@nokia.com>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] USB: fix interrupt disabling for HCDs with shared
 interrupt handlers
In-Reply-To: <200806301331.21077.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0806301728220.13119-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008, David Brownell wrote:

> On Monday 30 June 2008, Alan Stern wrote:
> > Don't bother with this extra stuff.  All USB host controller drivers
> > want to have interrupts disabled when their IRQ handlers run.
> 
> How about this one instead?  I think it's probably almost midnight
> where Stefan is, so I'd not expect Stefan to have an updated
> patch very soon ... :)

It certainly looks right.  We'll let Stefan test it.

Alan Stern

