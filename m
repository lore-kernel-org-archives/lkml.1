Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbXKQQNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbXKQQNf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 11:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbXKQQN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 11:13:28 -0500
Received: from netrider.rowland.org ([192.131.102.5]:4890 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751153AbXKQQN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 11:13:28 -0500
Date: Sat, 17 Nov 2007 11:13:24 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
In-Reply-To: <473F03DF.4020306@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0711171053500.29002-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Nov 2007, Jiri Slaby wrote:

> > The thing to do is figure out which driver is causing the problem.
> > Jiri, try enabling CONFIG_DEBUG_DRIVER.  
> 
> Sadly no output.

Guess I'll have to try running 2.6.24-rc2-mm1 on my own system.  In the 
meantime, you can try adding some printk statements to 
drivers/base/power/main.c.  In particular, see whether 
lock_all_devices() gets called from device_suspend(), whether it 
returns, and how far dpm_suspend() manages to get.

Alan Stern

