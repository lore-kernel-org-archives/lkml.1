Return-Path: <linux-kernel-owner+w=401wt.eu-S1759283AbYABQGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283AbYABQGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 11:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbYABQGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 11:06:40 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:60263 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755008AbYABQGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 11:06:40 -0500
Date: Wed, 2 Jan 2008 11:06:39 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dave Young <hidave.darkstar@gmail.com>
cc: Greg KH <gregkh@suse.de>, Peter Zijlstra <peterz@infradead.org>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
In-Reply-To: <a8e1da0801011658u24d7d399kb187c23300353682@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0801021105520.5062-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jan 2008, Dave Young wrote:

> > Around a month ago I had a discussion with Peter Zijlstra about the
> > problems in converting the device semaphores to mutexes; you may be
> > able to find it in the LKML archives.  Doing the conversion while
> > keeping lockdep happy is a very hard problem and we were not able to
> > solve it.
> >
> 
> It's unfortunate to know this, I will search and read your thread.

Here's a pointer to that thread:

	http://marc.info/?t=119411942200002&r=1&w=2

Alan Stern

