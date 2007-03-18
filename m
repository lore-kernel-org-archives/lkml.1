Return-Path: <linux-kernel-owner+w=401wt.eu-S1752650AbXCRQLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbXCRQLp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 12:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbXCRQLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 12:11:45 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2195 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752650AbXCRQLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 12:11:44 -0400
Date: Sun, 18 Mar 2007 12:11:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: Jiri Kosina <jikos@jikos.cz>, <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
In-Reply-To: <45FD5EA1.6040706@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0703181211080.19508-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Mar 2007, Jiri Slaby wrote:

> Alan Stern napsal(a):
> > On Sun, 18 Mar 2007, Jiri Slaby wrote:
> > 
> >> Alan Stern napsal(a):
> >>> In drivers/usb/host/uhci-q.c, near the start is a function named
> >>> uhci_fsbr_on().  Put a "return" statement right at its beginning so that
> >>> the function doesn't do anything.  Does that make any difference?
> >> Yes, it works.
> > 
> > Okay.  Take out that extra "return" statement and revert the WARN_ON, and
> > try this patch.  I don't like it because it adds extra PCI bus overhead to
> > the driver, but if some systems need it then there's no choice.
> 
> Yes, I'm proud to let you know, that it solves the problem :).
> 
> thanks a lot,

Okay, I'll run some tests of my own and submit it.

Alan Stern

