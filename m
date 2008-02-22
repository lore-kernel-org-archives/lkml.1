Return-Path: <linux-kernel-owner+w=401wt.eu-S1760925AbYBVQzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925AbYBVQzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYBVQyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:54:55 -0500
Received: from rtr.ca ([76.10.145.34]:4296 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbYBVQyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:54:54 -0500
Message-ID: <47BEFE5C.6080808@rtr.ca>
Date: Fri, 22 Feb 2008 11:54:52 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>, Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk.
 Screen becomes green.
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802202336.45492.rjw@sisk.pl> <alpine.LFD.1.00.0802201455430.7833@woody.linux-foundation.org> <200802210035.14058.rjw@sisk.pl>
In-Reply-To: <200802210035.14058.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
>
> No.  Again, if there are devices that wake us up from S4, but not from S5,
> they need to be handled differently in the *enter S4* case (hibernation) and
> in the *enter S5* case (powering off the system).
..

Something I've never understood, is why we would ever want to bother with *S4* at all?

I actually like hibernation (great for travelling), but I treat it as if
it were a complete power-off (S5?).  I pull batteries, unplug drives,
boot other operating systems, etc..

And when I put it all back together again with the Linux disk inserted,
I fully expect it to "resume" from the hibernation of 3 months ago.
And it does.

Why would I ever want anything less than a full poweroff for hibernation ????

Thanks.
