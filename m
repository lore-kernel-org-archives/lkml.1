Return-Path: <linux-kernel-owner+w=401wt.eu-S933379AbXK2WQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379AbXK2WQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932735AbXK2WQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:16:30 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:38216 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932728AbXK2WQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:16:29 -0500
Date: Thu, 29 Nov 2007 17:16:28 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: kobject_init rewrite
In-Reply-To: <20071129215304.GA5043@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0711291713330.6294-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Greg KH wrote:

> Ok, how about this function.  If it errors out, it is free to just call
> kfree() on the kobject.  Seems simple enough to me, any objections?  If
> not, I'll go through and fix up the whole tree...

Looks good, _provided_ you also get rid of kobject_register().  Which 
you pretty much would have to do anyway, since it doesn't accept the 
ktype or the name as an argument.

Alan Stern

