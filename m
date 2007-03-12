Return-Path: <linux-kernel-owner+w=401wt.eu-S1752443AbXCLTbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbXCLTbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 15:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbXCLTbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 15:31:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40590 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752443AbXCLTbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 15:31:34 -0400
Date: Mon, 12 Mar 2007 15:31:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
In-Reply-To: <200703121925.01771.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.0703121527290.3205-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007, Oliver Neukum wrote:

> > I'm with Dmitry; the whole thing becomes much, much simpler if we put back
> > your patch and prevent sysfs access after unregistering an attribute 
> > file.  No API changes are needed, no driver changes are needed, no radical 
> > core changes are needed,...  All we would have to do is fix the one SCSI 
> > method to make it use a workqueue.
> 
> Try.

I did.  Didn't you see this message from Saturday:

http://marc.theaimsgroup.com/?l=linux-kernel&m=117355959020831&w=2

I sent it to Linus as well as to all of you.  No replies received so far 
from anybody.

>  I don't like reverting my own code. But I predict he'll tell you that a
> driver's bond with a device should be represented in a data structure
> that is to be refcounted.

:-)

Alan Stern

