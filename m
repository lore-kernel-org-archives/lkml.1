Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbZCCSCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbZCCSCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 13:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbZCCSCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 13:02:03 -0500
Received: from mail.polezero.com ([216.68.55.34]:35872 "EHLO
	firewall.polezero.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751084AbZCCSCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 13:02:01 -0500
Subject: Re: New HID device support
From: Jason Noble <nobleja@polezero.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.0903031720380.5295@jikos.suse.cz>
References: <1236096277.26321.29.camel@paradox.pz.local>
	 <alpine.LNX.2.00.0903031720380.5295@jikos.suse.cz>
Content-Type: text/plain
Date: Tue, 03 Mar 2009 13:01:49 -0500
Message-Id: <1236103310.12185.1.camel@paradox.pz.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 17:21 +0100, Jiri Kosina wrote:
> On Tue, 3 Mar 2009, Jason Noble wrote:
> 
> > Jiri,
> > 	After a bit of googling I'm pretty sure you are the person to ask for
> > help.
> > 
> > I have a new Kensington Slimblade Trackball 
> > http://us.kensington.com/html/16632.html. This device just recently 
> > started shipping, I'm probably one of the first few people to connect 
> > one to linux.
> > 
> > Using "evtest /dev/input/eventX" two of the four buttons are not
> > registering at all. With usbmon I can see data coming from these
> > buttons.
> > Can you help? If so, what info do you need?
> > If not, can you point me in the correct direction?
> 
> Could you please compile your kernel with CONFIG_HID_DEBUG, modprobe the 
> 'hid' module with 'debug=2' option, and send me the output that appears in 
> dmesg when you

On a monolithic kernel I just pass usbhid.debug=2 at boot correct?

> 
> - connect the device
> - press the non-working buttons
> 
> Thanks,
> 

