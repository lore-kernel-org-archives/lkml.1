Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbZIRRQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbZIRRQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 13:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbZIRRQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 13:16:31 -0400
Received: from kroah.org ([198.145.64.141]:40975 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbZIRRQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 13:16:31 -0400
Date: Fri, 18 Sep 2009 10:16:06 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jason Wessel <jason.wessel@windriver.com>, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] usb console: fix mutex lock regression
Message-ID: <20090918171606.GA22273@kroah.com>
References: <1253156887-31597-2-git-send-email-jason.wessel@windriver.com>
 <Pine.LNX.4.44L0.0909162324460.24041-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0909162324460.24041-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 11:25:40PM -0400, Alan Stern wrote:
> On Wed, 16 Sep 2009, Jason Wessel wrote:
> 
> > During the 2.6.32 development the use of serial->disc_mutex was
> > introduced.  In usb_console_setup() the call to
> > usb_serial_get_by_index() will obtain this mutex. The
> > usb_console_setup() must release the mutex before it completes else
> > later calls to the usb serial core will hang.
> 
> Apparently you didn't see my patch:
> 
> 	http://marc.info/?l=linux-usb&m=125209260714221&w=2
> 
> Did this not get into linus-next?  Greg?

Bah, my fault, I forgot this after I fixed up my tree and took your
other patches.

I've now added this one, so all should be good.

My appologies.

greg k-h
