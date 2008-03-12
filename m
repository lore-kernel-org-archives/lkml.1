Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbYCLWdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbYCLWdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbYCLWcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:32:53 -0400
Received: from eazy.amigager.de ([213.239.192.238]:33397 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbYCLWcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:32:52 -0400
Date: Wed, 12 Mar 2008 23:33:25 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: broken access to a USB HID device after suspend
Message-ID: <20080312223325.GA2290@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20080312193405.GA23209@dose.home.local> <Pine.LNX.4.64.0803122217580.7266@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803122217580.7266@twin.jikos.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 22:23:46 +0100, Jiri Kosina wrote:
> On Wed, 12 Mar 2008, Tino Keitel wrote:
> 
> > I use a tool called hidmon to control the parameters of my LCD in shell
> > scripts. I just had the case where this tool didn't work after suspend
> > to RAM. I just got this error message:
> > 
> > hid_force_open failed with return code 13
> > 
> > The kernel log contains lines like this:
> > 
> > usb 1-1.3: usbfs: USBDEVFS_CONTROL failed cmd hidmon rqt 129 rq 6 len 9 ret -110
> > 
> > Unplugging and replugging the USB cable of the LCD didn't work.
> > However, after a further suspend/resume cycle it works.
> > 
> > This is Linux 2.6.25-rc5. The behaviour is not repoducible, though.
> > However, I just mention it for the case that this might ring a bell
> > somewhere.
> 
> This in fact looks like a problem with usbdevfs and/or libusb library, not 
> the in-kernel HID drvier.
> 
> Did this work before? In 2.6.24? 2.6.23? Alan (added to CC, as well as USB 

It worked in 2.6.24 and several 2.6.25-rc kernels, including the
currently running 2.6.25-rc5.

Regards,
Tino
