Return-Path: <linux-kernel-owner+w=401wt.eu-S1752926AbZGWSVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbZGWSVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 14:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbZGWSVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 14:21:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47573 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752523AbZGWSVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 14:21:39 -0400
Date: Thu, 23 Jul 2009 14:21:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ferenc Wagner <wferi@niif.hu>, <linux-kernel@vger.kernel.org>,
       <alan@lxorguk.ukuu.org.uk>, <linux-usb@vger.kernel.org>
Subject: Re: 2.6.31-rc3: replugging USB serial converter uses new device node
In-Reply-To: <20090723104809.6d39b03b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0907231420280.3509-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009, Andrew Morton wrote:

> > > > Since upgrading to 2.6.31-rc3 from 2.6.30, my ttyUSB device number
> > > > keeps increasing on each replug.  Output of udevadm monitor:
> > ...
> > > > Dmesg is available at http://pastebin.com/d516e3e00.
> > > 
> > > Can anyone say whether this is expected behaviour?
> > 
> > It depends on whether a program is still holding the old device file 
> > open when the replug occurs.
> 
> But this is new behaviour in 2.6.31-rcX.  Was something changed in this area?

The tty core and usb-serial have both undergone extensive changes, 
courtesy of Alan Cox.

Alan Stern

