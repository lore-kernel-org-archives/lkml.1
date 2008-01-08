Return-Path: <linux-kernel-owner+w=401wt.eu-S1762436AbYAHQ5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762436AbYAHQ5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbYAHQ5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:57:00 -0500
Received: from twin.jikos.cz ([213.151.79.26]:54922 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593AbYAHQ47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:56:59 -0500
Date: Tue, 8 Jan 2008 17:54:02 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: David Brownell <david-b@pacbell.net>
cc: Alan Stern <stern@rowland.harvard.edu>,
       Dave Young <hidave.darkstar@gmail.com>, Greg KH <gregkh@suse.de>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
In-Reply-To: <200712292242.47960.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.64.0801081752350.25041@twin.jikos.cz>
References: <Pine.LNX.4.44L0.0712291652540.26261-100000@netrider.rowland.org>
 <200712292242.47960.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Dec 2007, David Brownell wrote:

> > There's no way to remove these, which means there's no way to prevent 
> > lockdep from issuing a warning.
> There may be no *efficient* way to do that.  If it tracked every lock 
> individually these false alarms could go away; but that would increase 
> the overhead to create and destroy such locks too.

And it would also do something completely different compared to what 
lockdep is doing now.

The point is being able to spot the potential deadlock before it actually 
happens. If you track individual instances instead of classess, you are 
out of luck with this.

-- 
Jiri Kosina
