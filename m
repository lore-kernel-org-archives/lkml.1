Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbYCNHNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbYCNHNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 03:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbYCNHNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 03:13:05 -0400
Received: from eazy.amigager.de ([213.239.192.238]:40070 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbYCNHNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 03:13:04 -0400
Date: Fri, 14 Mar 2008 08:13:36 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: broken access to a USB HID device after suspend
Message-ID: <20080314071336.GA14550@dose.home.local>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org
References: <20080313151403.GA5667@dose.home.local> <Pine.LNX.4.44L0.0803131450370.5744-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0803131450370.5744-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 14:59:48 -0400, Alan Stern wrote:

[...]

> > Well, it seems to be "fixed" by a suspend/resume cycle. Do you have
> > a
> > hint how I could try to fix it without suspend/resume, to test if
> > it is
> > really the LCD's fault?
>
> Testing has to come before fixing -- you can't fix the problem if you
> don't know which component is at fault.  For all we know, the
> hardware
> could be fine and the problem could lie in your application.

I meant a method other than suspend/resume to fix the broken behaviour,
so that we get an indication where the problem exactly is.

>
> All I can think of for testing is to use usbmon to record the data
> transfers when those -110 errors come up.

Well, I still don't have USB_DEBUG or usbmon enabled, but I just got
that error again. I pulled the power plug from the LCD and replugged
it, without success. Then I did a suspend/resume cycle, and it worked.

Regards,
Tino
