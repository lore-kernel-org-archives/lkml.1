Return-Path: <linux-kernel-owner+w=401wt.eu-S933094AbZLNWM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094AbZLNWM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932847AbZLNWMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:12:19 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:47954 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675AbZLNWMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:12:16 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Warn people about flush_scheduled_work()
Date: Mon, 14 Dec 2009 23:12:20 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0912141701040.2690-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912141701040.2690-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912142312.20163.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 14. Dezember 2009 23:02:51 schrieb Alan Stern:
> On Mon, 14 Dec 2009, Oliver Neukum wrote:
> 
> > Am Montag, 14. Dezember 2009 22:33:38 schrieb Alan Stern:
> > >         Consider using cancel_work_sync() or cancel_delayed_work_sync()
> > >         instead.  In most situations they will accomplish what you 
> > >         need.
> > 
> > In which respect is cancel_work_sync() fundamentally safer?
> > If the work is already running and takes a lock you are holding,
> > then what?
> 
> With cancel_work_sync() you know what locks the work item is going to
> take, since it's your work item.  With flush_scheduled_work() you have
> no idea what locks will be needed by the items on the queue.  They 
> could come from anywhere.

True, but what use is that if you don't know your call chain and the locks
it takes.

	Regards
		Oliver
