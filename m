Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbZGWOoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbZGWOoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZGWOoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:44:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55617 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752137AbZGWOoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:44:14 -0400
Date: Thu, 23 Jul 2009 10:44:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ferenc Wagner <wferi@niif.hu>, <linux-kernel@vger.kernel.org>,
       <alan@lxorguk.ukuu.org.uk>, <linux-usb@vger.kernel.org>
Subject: Re: 2.6.31-rc3: replugging USB serial converter uses new device node
In-Reply-To: <20090723012140.39f697d2.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0907231042040.2825-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009, Andrew Morton wrote:

> (cc linux-usb)
> 
> On Sat, 18 Jul 2009 22:04:57 +0200 Ferenc Wagner <wferi@niif.hu> wrote:
> 
> > Hi,
> > 
> > Since upgrading to 2.6.31-rc3 from 2.6.30, my ttyUSB device number
> > keeps increasing on each replug.  Output of udevadm monitor:
...
> > Dmesg is available at http://pastebin.com/d516e3e00.
> 
> Can anyone say whether this is expected behaviour?

It depends on whether a program is still holding the old device file 
open when the replug occurs.

> Does it actually cause any observeable problems?  I expect things will
> get ugly once it runs out of range.

The numbers will get reused after the corresponding device files are
closed.

For further discussion, see this thread:

	http://marc.info/?t=124828810800002&r=1&w=2

Alan Stern

