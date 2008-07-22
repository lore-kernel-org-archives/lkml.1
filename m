Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbYGVJDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbYGVJDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 05:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYGVJDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 05:03:34 -0400
Received: from li26-190.members.linode.com ([67.18.89.190]:46836 "EHLO
	notebook.homenet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751414AbYGVJDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 05:03:33 -0400
Date: Tue, 22 Jul 2008 11:03:31 +0200
From: Tomas Styblo <tripie@cpan.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix -
	device 152d:2338
Message-ID: <20080722090331.GC8303@notebook.homenet.local>
References: <4884E585.2050104@shaw.ca> <Pine.LNX.4.44L0.0807212232001.5882-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0807212232001.5882-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Stern <stern@rowland.harvard.edu> [Tue, 22 Jul 2008]:
> On Mon, 21 Jul 2008, Robert Hancock wrote:
> > > this message includes a patch that provides a workaround for
> > > a silent data corruption bug caused by incorrect error handling in
> > > the JMicron JM20337 Hi-Speed USB to SATA & PATA Combo Bridge chipset,
> > > USB device id 152d:2338.
> 
> The two of you should read through
> 
> 	http://bugzilla.kernel.org/show_bug.cgi?id=9638
> 
> which concerns this very problem.

I had found this bugreport and read through it before I posted my
patch. I don't think this is the same problem. The error messages
and the description of the problem are different from what I've
been trying to fix.

Anyway, I'll send the patch to this person so he can try it. 
I guess it won't fix his problem. This patch is much simpler and doesn't 
need any delays - I really think this is a different situation.

I sometimes experience the problems described by this person, as I
noted in the first message with the patch. When these "reset high
speed USB device" messages appear, it is usually necessary to
disconnect and power off the device. In my experience, data
corruption can be prevented in this situation by setting:

# tune2fs -e remount-ro /dev/sdX

But this is a different problem - in this situation the error
actually IS detected.



-- 
Tomas Styblo <tripie@cpan.org>
