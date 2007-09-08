Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbXIHNp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbXIHNp6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 09:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbXIHNpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 09:45:50 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4778 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751983AbXIHNpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 09:45:49 -0400
Date: Sat, 8 Sep 2007 09:38:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <gregkh@suse.de>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Oliver Neukum <oliver@neukum.org>, Tino Keitel <tino.keitel@gmx.de>
Subject: Re: [2/4] 2.6.23-rc5: known regressions v2
In-Reply-To: <20070908122852.GA30315@suse.de>
Message-ID: <Pine.LNX.4.44L0.0709080935400.20265-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Sep 2007, Greg KH wrote:

> On Sat, Sep 08, 2007 at 01:11:13PM +0200, Michal Piotrowski wrote:
> > USB
> > 
> > Subject         : 2.6.23-rc1: USB hard disk broken
> > References      : http://lkml.org/lkml/2007/7/25/62
> > Last known good : ?
> > Submitter       : Tino Keitel <tino.keitel@gmx.de>
> > Caused-By       : ?
> > Handled-By      : Oliver Neukum <oliver@neukum.org>
> > Status          : unknown
> > 
> > Subject         : USB hard disk broken in 2.6.23-rc3 (autosuspend related)
> > References      : http://bugzilla.kernel.org/show_bug.cgi?id=8892
> > Last known good : ?
> > Submitter       : Roman Jarosz <kedgedev@centrum.cz>
> > Caused-By       : ?
> > Handled-By      : Alan Stern <stern@rowland.harvard.edu>
> > Workaround      : echo -1 >/sys/bus/usb/devices/1-4/power/autosuspend
> > Status          : possible hardware problem
> 
> Oliver and Alan, is there any info about these?  Anything that I can
> help out with?

We're still waiting to hear back from Tino.

Last week I submitted a patch adding Roman's device to the USB quirks 
list.  IIRC the device is one of those troublesome Genesys USB-IDE 
adapters; most of the time it resumes correctly but every now and then 
it fails.  The patch should be somewhere on your input queue.

Alan Stern

