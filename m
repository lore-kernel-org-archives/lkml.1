Return-Path: <linux-kernel-owner+w=401wt.eu-S935814AbZLHD14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935814AbZLHD14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 22:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935761AbZLHD1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 22:27:53 -0500
Received: from netrider.rowland.org ([192.131.102.5]:39000 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935161AbZLHD1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 22:27:53 -0500
Date: Mon, 7 Dec 2009 22:27:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <200912080051.13061.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0912072225390.4179-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Dec 2009, Rafael J. Wysocki wrote:

> However, the parent can be on a different bus type than the children, so it
> looks like we can only start the asynchronous path at the core level.

Agreed.

> > Unless you want to do _all_ of the async logic in generic code and 
> > re-introduce the "dev->async_suspend" flag.
> 
> Quite frankly, I would like to.
> 
> > I would be ok with that now that the infrastructure seems so simple.
> 
> Well, perhaps I should dig out my original async suspend/resume patches
> that didn't contain all of the non-essential stuff and post them here for
> discussion, after all ...

That seems like a very good idea.  IIRC they were quite similar to what 
we have been discussing.

Alan Stern

