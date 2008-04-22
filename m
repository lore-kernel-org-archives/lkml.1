Return-Path: <linux-kernel-owner+w=401wt.eu-S1761246AbYDVOz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761246AbYDVOz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbYDVOzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:55:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33934 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750726AbYDVOzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:55:18 -0400
Date: Tue, 22 Apr 2008 10:55:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andy Whitcroft <apw@shadowen.org>
cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: False positive in checkpatch (2.6.25)
In-Reply-To: <20080422080547.GC26446@shadowen.org>
Message-ID: <Pine.LNX.4.44L0.0804221054310.8058-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2008, Andy Whitcroft wrote:

> On Thu, Apr 17, 2008 at 03:33:48PM -0400, Alan Stern wrote:
> 
> > ERROR: space prohibited after that '*' (ctx:ExW)
> > #15: FILE: drivers/usb/core/driver.c:1544:
> > +        * when the system suspend started, so we don't want to resume it
> >          ^
> > 
> > ERROR: Missing Signed-off-by: line(s)
> 
> Yes, pretty sure that was triggered by a bug in comment tracking when
> it moved into quote tracking.  From my testing here it should have been
> fixed in v0.17, you have v0.16.  Andrew has the change queued up so it
> should be on its way to mainline.  You can get the latest from the url
> below to confirm:
> 
> 	http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/
> 
> Thanks for the report.

Confirmed: checkpatch.pl-next doesn't have this problem.

Alan Stern

