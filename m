Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbXCLUDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbXCLUDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbXCLUDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:03:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35772 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752833AbXCLUDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:03:12 -0400
Date: Mon, 12 Mar 2007 16:03:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
In-Reply-To: <200703122049.03113.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.0703121557360.4003-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007, Oliver Neukum wrote:

> > >  I don't like reverting my own code. But I predict he'll tell you that a
> > > driver's bond with a device should be represented in a data structure
> > > that is to be refcounted.
> > 
> > :-)
> 
> Coming to think about it, he might be right there.

There still would be a synchronization problem.  Refcounts don't solve
races; they only solve lifetime problems.  And you would still have to
change the sysfs API, plus all the other stuff...

Do you think Linus would listen if all three of us (plus maybe Greg) tried 
to convince him?

Alan Stern

