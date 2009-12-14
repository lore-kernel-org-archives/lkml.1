Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbZLNXFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbZLNXFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:05:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932677AbZLNXFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:05:01 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37073 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758724AbZLNXEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:04:51 -0500
Date: Mon, 14 Dec 2009 18:04:51 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Tejun Heo <tj@kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Warn people about flush_scheduled_work()
In-Reply-To: <200912142312.20163.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0912141803000.2690-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009, Oliver Neukum wrote:

> Am Montag, 14. Dezember 2009 23:02:51 schrieb Alan Stern:
> > On Mon, 14 Dec 2009, Oliver Neukum wrote:
> > 
> > > Am Montag, 14. Dezember 2009 22:33:38 schrieb Alan Stern:
> > > >         Consider using cancel_work_sync() or cancel_delayed_work_sync()
> > > >         instead.  In most situations they will accomplish what you 
> > > >         need.
> > > 
> > > In which respect is cancel_work_sync() fundamentally safer?
> > > If the work is already running and takes a lock you are holding,
> > > then what?
> > 
> > With cancel_work_sync() you know what locks the work item is going to
> > take, since it's your work item.  With flush_scheduled_work() you have
> > no idea what locks will be needed by the items on the queue.  They 
> > could come from anywhere.
> 
> True, but what use is that if you don't know your call chain and the locks
> it takes.

Okay, clearly you have to know something about your call chain.  The
comment should be toned down a little bit.

Alan Stern

