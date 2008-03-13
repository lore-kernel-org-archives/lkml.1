Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbYCMS77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbYCMS77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 14:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbYCMS7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 14:59:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45097 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754121AbYCMS7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 14:59:49 -0400
Date: Thu, 13 Mar 2008 14:59:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tino Keitel <tino.keitel@gmx.de>
cc: Jiri Kosina <jkosina@suse.cz>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: broken access to a USB HID device after suspend
In-Reply-To: <20080313151403.GA5667@dose.home.local>
Message-ID: <Pine.LNX.4.44L0.0803131450370.5744-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008, Tino Keitel wrote:

> > Then you suspended the computer with no apparent problem.
> > 
> > Two days later you suspended three more times, and the the LCD monitor
> > was disconnected during the third suspend.  When it came back, you
> 
> What log message do you refer to here?

The three resumes took place on March 12 at 05:21:02, 06:00:28, and 
19:20:08 (it's not always clear in the log what time the suspends took 
place).  The timestamp on the disconnect message is 19:20:09.37743.  In 
the next line the device was rediscovered.

> > To me that makes it look like the LCD's problems have no connection at
> > all with suspend/resume.
> 
> Well, it seems to be "fixed" by a suspend/resume cycle. Do you have a
> hint how I could try to fix it without suspend/resume, to test if it is
> really the LCD's fault?

Testing has to come before fixing -- you can't fix the problem if you
don't know which component is at fault.  For all we know, the hardware
could be fine and the problem could lie in your application.

All I can think of for testing is to use usbmon to record the data 
transfers when those -110 errors come up.

Alan Stern

