Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbXECNd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbXECNd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 09:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbXECNd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 09:33:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42583 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754125AbXECNdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 09:33:25 -0400
Date: Thu, 3 May 2007 09:33:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Lord <lkml@rtr.ca>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, <marcel@holtmann.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@osdl.org>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [BUG] usb/core/hub.c loops forever on resume
 from ram due to bluetooth
In-Reply-To: <463904F4.8030709@rtr.ca>
Message-ID: <Pine.LNX.4.44L0.0705030932290.3548-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Mark Lord wrote:

> Alan Stern wrote:
> > 
> > A better approach would be to find out why your system gets into that loop 
> > and fix the underlying cause.
> 
> Not better, just parallel.
> 
> That loop should not be unbounded, as this example proves.
> But it also shouldn't get stuck there regardless.
> 
> Two fixes needed.

If the code never gets stuck in a loop, then there's no need to check 
whether the loop is unbounded!  :-)

So only one fix needed.

Alan Stern

