Return-Path: <linux-kernel-owner+w=401wt.eu-S966817AbXEVTEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966817AbXEVTEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 15:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966755AbXEVTEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 15:04:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54239 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966754AbXEVTEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 15:04:12 -0400
Message-ID: <46533EA8.7020602@garzik.org>
Date: Tue, 22 May 2007 15:04:08 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [stable] Wanted: Allow adding new device IDs during the	-stable
 cycle
References: <46533314.10206@redhat.com> <20070522184733.GA9357@kroah.com>
In-Reply-To: <20070522184733.GA9357@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> What's wrong with the current sysfs way of adding new device ids without
> touching the kernel?  Devices described above was the very reason we
> added that functionality, so users would not have to constantly update
> their kernel.  The distros provide userspace tools that enable these ids
> to be added and at boot time, everything "just works" properly.

I haven't found a single distro that (a) makes it trivial to add PCI IDs 
at install time, and then (b) ensures those PCI IDs remain persistent 
for each boot.  We are not at all to the "just works" stage yet.

> So, because of that, I don't really see a need to be adding new device
> ids to the -stable tree.

Maybe you are just not seeing all the developers that keep bringing this 
up??

Really, it is just silly to think that one-line PCI IDs patches will 
cause any harm at all, and it should be self-evident that there is clear 
potential to HELP Linux users.  That's why we're all here, right?

	Jeff


