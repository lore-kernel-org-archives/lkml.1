Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbXIUOTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbXIUOTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760085AbXIUOSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:18:54 -0400
Received: from twin.jikos.cz ([213.151.79.26]:46212 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760078AbXIUOSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:18:53 -0400
Date: Fri, 21 Sep 2007 16:18:42 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: USB autosuspend and turning of usb pendrive leds
In-Reply-To: <46F3C704.5000203@hhs.nl>
Message-ID: <Pine.LNX.4.64.0709211615520.22331@twin.jikos.cz>
References: <46F3C704.5000203@hhs.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(linux-usb-devel needs CC)

On Fri, 21 Sep 2007, Hans de Goede wrote:

> 1) Would it be possible to funtionality to the kernel to suspend a device in
>    such a way that it will automatically unsuspend when used again?

It is possible - USB now supports autosuspend. After a long debate, it was 
however devcided that it is explicitly turned off, and userspace is free 
to turn it on via sysfs interface for whatever devices the user likes to 
do so.

This is mainly because there is a huge load of USB devices out there that 
don't support this feature correctly, and we will break them if we perform 
autosuspend automatically.

> 2) Would it be possible to still make the polls succeed then with out 
>    unsuspending the device (or atleast without doing something that 
>    would make the led light again, what makes the led light exactly is 
>    unknown), or should hal stop polling then?

How would you know how exactly respond to poll() that no userspace program 
gets confused? There are many different kinds of USB devices.

-- 
Jiri Kosina
