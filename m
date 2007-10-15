Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbXJOVqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbXJOVqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbXJOVqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:46:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34240 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbXJOVqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:46:32 -0400
Message-ID: <4713DFA8.6020304@garzik.org>
Date: Mon, 15 Oct 2007 17:46:16 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Neil Brown <neilb@suse.de>, Theodore Tso <tytso@mit.edu>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
Subject: Re: What still uses the block layer?
References: <200710112011.22000.rob@landley.net> <200710150304.00901.rob@landley.net> <18195.19678.500863.613193@notabene.brown> <200710151634.57407.rob@landley.net>
In-Reply-To: <200710151634.57407.rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> I realize that both views are valid.  This is why the US has a house and a 
> senate, and filters things through both views.  My gripe is that forcing my 
> laptop to look at my USB devices to find my SATA hard drive is aligned with 
> only one of those viewpoints, and completely opposed to the other.
> 
> An approach that makes things much easier on laptops is seen to hurt big iron, 
> not because it the approach itself has a direct negative impact on big iron, 
> but only because then laptops are not saddled with the problems of big iron.


And we are telling you that, in a modern hotplug world -- yes even on a 
laptop -- you are clinging too much to assumptions that were never 100% 
true in the first place, and much less so on today's laptops.

When you can unplug a SATA drive from a laptop, and plug it back in via 
USB, you can see how unwise it is to hardcode device names into your fstab.

We invented udev, sysfs, mount-by-label, mount-by-uuid, LVM and all 
sorts of other gadgets to make this problem go away.

If you ignore the solutions that exist to solve these problems, then of 
course annoyances will persist as the state of hardware marches forward.

	Jeff


