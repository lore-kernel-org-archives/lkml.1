Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318Ab0CKQ4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 11:56:25 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35888 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933247Ab0CKQ4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 11:56:24 -0500
Date: Thu, 11 Mar 2010 11:56:22 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mel Gorman <mel@csn.ul.ie>
cc: Markus Rechberger <mrechberger@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: USBFS Memory allocation Bug
In-Reply-To: <20100310155519.GO4883@csn.ul.ie>
Message-ID: <Pine.LNX.4.44L0.1003111155030.1367-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010, Mel Gorman wrote:

> > > Is there any means for the driver to take the large request, break it up
> > > into multiple smaller requests and submit them one at a time?
> > 
> > In theory almost anything is possible.  But it would be a big effort
> > and not consistent with the way the rest of the driver works.
> > 
> 
> Then about the only other suggestion would be a mempool containing a small
> number of largest-possible buffers that is enabled if there is no swap
> available.

Considering that this is the first report I have heard about this sort 
of problem, and that adding swap space would probably fix it, I'm not 
inclined to make any changes.

Alan Stern

