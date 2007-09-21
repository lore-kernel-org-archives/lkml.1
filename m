Return-Path: <linux-kernel-owner+w=401wt.eu-S1760396AbXIUOfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760396AbXIUOfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758612AbXIUOfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:35:39 -0400
Received: from frosty.hhs.nl ([145.52.2.15]:36265 "EHLO frosty.hhs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758294AbXIUOfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:35:38 -0400
Message-ID: <46F3D326.6050804@hhs.nl>
Date: Fri, 21 Sep 2007 16:20:22 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net,
       Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: USB autosuspend and turning of usb pendrive leds
References: <46F3C704.5000203@hhs.nl> <Pine.LNX.4.64.0709211615520.22331@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0709211615520.22331@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.2/RELEASE, bases: 21092007 #395964, status: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

<please use reply to all to keep me cc-ed, I'm not subscribed>

Jiri Kosina wrote:
> On Fri, 21 Sep 2007, Hans de Goede wrote:
> 
>> 1) Would it be possible to funtionality to the kernel to suspend a device in
>>    such a way that it will automatically unsuspend when used again?
> 
> It is possible - USB now supports autosuspend. After a long debate, it was 
> however devcided that it is explicitly turned off, and userspace is free 
> to turn it on via sysfs interface for whatever devices the user likes to 
> do so.
> 

Thats not what I had in mind, autosuspend doesn't work (presumably because hal 
keeps polling for media change) maybe I should fix hal to not keep polling for 
devices which don't have removable media?

What one was able todo some time ago when there still was a power/state sysfs 
entry for usb devices, was suspend the device without changing the autosuspend 
state and then it would wake automatically when used again, I think it would be 
easiest for hal to see this behaviour back.

Note I'm not saying that this behaviour should be brought back, currently I'm 
mainly trying to find out what hal may / may not expect from the kernel with 
regards to usb suspend in the future so that I can write a hal patch based on that.

Regards,

Hans

