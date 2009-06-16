Return-Path: <linux-kernel-owner+w=401wt.eu-S1759206AbZFPOab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206AbZFPOab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 10:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbZFPOaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 10:30:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55770 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752911AbZFPOaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 10:30:18 -0400
Date: Tue, 16 Jun 2009 10:30:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>, Magnus Damm <damm@igel.co.jp>,
       <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of
 I/O devices
In-Reply-To: <200906160121.40843.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906161028480.3740-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009, Rafael J. Wysocki wrote:

> > Since pm_runtime_resume() takes care of powering up the parent, there's 
> > no need for pm_request_resume() to worry about it also.
> 
> But still it won't hurt to do it IMO, because the parents are then going to be
> resumed before our pm_runtime_resume() is called.

It's extra code that isn't needed.  In essence, you are trading code
space for a shorter runtime stack.

> > The documentation should mention that the runtime_suspend method is 
> > supposed to enable remote wakeup if it as available and if 
> > device_may_wakeup(dev) is true.
> 
> Well, I thought that was obvious. :-)

Sometimes it doesn't hurt to state the obvious!  :-)

Alan Stern

