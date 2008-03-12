Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbYCLWns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbYCLWns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYCLWnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:43:40 -0400
Received: from eazy.amigager.de ([213.239.192.238]:39263 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbYCLWnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:43:39 -0400
Date: Wed, 12 Mar 2008 23:44:11 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: broken access to a USB HID device after suspend
Message-ID: <20080312224411.GB2290@dose.home.local>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org
References: <Pine.LNX.4.64.0803122217580.7266@twin.jikos.cz> <Pine.LNX.4.44L0.0803121739590.6966-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0803121739590.6966-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 17:44:56 -0400, Alan Stern wrote:

[...]

> Tino, it would help to see a kernel log showing what happened during 
> the suspend, resume, and failure of hidmon.  It would help even more if 
> you test under a kernel with CONFIG_USB_DEBUG enabled.

A full kernel log is available at http://tikei.de/dmesg

> 
> Even if you can't reproduce the problem, do you have the complete 
> kernel log from before?
> 
> Is it possible that this is really a problem with the LCD device, not 
> with the kernel?  I ask because if the device was working properly then 
> unplugging and replugging the USB cable should do a complete reset.

I did the following:

- suspended the computer

- switched off the LCD

- resumed the computer

- tried to use hidmon, got the error

- unplugged the LCD

- plugged in the LCD

- tried to use hidmon again, got the error again

- suspended the computer

- resumed the computer

- tried to use hidmon again, and it worked

Note that I didn't switch off the LCD during the second suspend, in the
case that matters.

Regards,
Tino
