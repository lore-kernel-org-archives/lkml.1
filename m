Return-Path: <linux-kernel-owner+w=401wt.eu-S1759441AbYFTPbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbYFTPbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758480AbYFTPbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:31:40 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:45248 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043AbYFTPbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:31:39 -0400
Date: Fri, 20 Jun 2008 09:31:37 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, dsd@gentoo.org,
       mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org,
       vegardno@ifi.uio.no, James.Bottomley@hansenpartnership.com,
       linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting root
Message-ID: <20080620153137.GT4392@parisc-linux.org>
References: <20080619182310.GA30833@parisc-linux.org> <Pine.LNX.4.44L0.0806191735570.2229-100000@iolanthe.rowland.org> <19f34abd0806200815t49b59df9sd9567b52482eaee3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806200815t49b59df9sd9567b52482eaee3@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 05:15:43PM +0200, Vegard Nossum wrote:
> On Thu, Jun 19, 2008 at 11:39 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > As I recall, it died because the whole notion was very poorly defined
> > to begin with.  The idea was to stop waiting when all the SCSI buses
> > had been scanned -- but there's no way to know when that occurs because
> > new buses can be added at any time.
> 
> Can you please explain why this is?

The USB spec doesn't mandate a minimum time before devices come
available.  There's no way for the device to say "I'm here, I will be
providing USB Storage, but I'm not ready yet".  So we can't know when
we've enumerated all the USB devices on the system.


-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
