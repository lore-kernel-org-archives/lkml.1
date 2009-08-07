Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbZHGN7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbZHGN7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 09:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757399AbZHGN7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 09:59:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38442 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757322AbZHGN7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 09:59:46 -0400
Date: Fri, 7 Aug 2009 09:59:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH update] PM: Introduce core framework for run-time PM of
 I/O devices (rev. 12)
In-Reply-To: <200908062350.25426.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908070957010.2886-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Aug 2009, Rafael J. Wysocki wrote:

> > If we defer a resume request while a suspend is in progress, then when
> > the suspend finishes should the resume be carried out immediately
> > rather than queued?  I don't see any reason why not.
> 
> Well, it's not very clear what to return to the caller in such a case.  I guess
> we can return -EAGAIN.

I would have said to return 0, just as if the resume had been queued.  
But it doesn't matter very much.

Alan Stern

