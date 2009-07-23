Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbZGWRtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbZGWRtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 13:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbZGWRtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 13:49:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752977AbZGWRtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 13:49:21 -0400
Date: Thu, 23 Jul 2009 10:48:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ferenc Wagner <wferi@niif.hu>, <linux-kernel@vger.kernel.org>,
       <alan@lxorguk.ukuu.org.uk>, <linux-usb@vger.kernel.org>
Subject: Re: 2.6.31-rc3: replugging USB serial converter uses new device
 node
Message-Id: <20090723104809.6d39b03b.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.0907231042040.2825-100000@iolanthe.rowland.org>
References: <20090723012140.39f697d2.akpm@linux-foundation.org>
	<Pine.LNX.4.44L0.0907231042040.2825-100000@iolanthe.rowland.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009 10:44:13 -0400 (EDT) Alan Stern <stern@rowland.harvard.edu> wrote:

> On Thu, 23 Jul 2009, Andrew Morton wrote:
> 
> > (cc linux-usb)
> > 
> > On Sat, 18 Jul 2009 22:04:57 +0200 Ferenc Wagner <wferi@niif.hu> wrote:
> > 
> > > Hi,
> > > 
> > > Since upgrading to 2.6.31-rc3 from 2.6.30, my ttyUSB device number
> > > keeps increasing on each replug.  Output of udevadm monitor:
> ...
> > > Dmesg is available at http://pastebin.com/d516e3e00.
> > 
> > Can anyone say whether this is expected behaviour?
> 
> It depends on whether a program is still holding the old device file 
> open when the replug occurs.

But this is new behaviour in 2.6.31-rcX.  Was something changed in this area?

> > Does it actually cause any observeable problems?  I expect things will
> > get ugly once it runs out of range.
> 
> The numbers will get reused after the corresponding device files are
> closed.
> 
> For further discussion, see this thread:
> 
> 	http://marc.info/?t=124828810800002&r=1&w=2
> 
> Alan Stern
