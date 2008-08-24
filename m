Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbYHXSir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbYHXSir (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 14:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYHXSii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 14:38:38 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:50409 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYHXSii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 14:38:38 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: converting appletouch to usb autosuspend again...
Date: Sun, 24 Aug 2008 20:39:48 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Jiri Kosina <jikos@jikos.cz>
References: <1219525218.8221.31.camel@localhost>
In-Reply-To: <1219525218.8221.31.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808242039.48701.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 23 August 2008 23:00:18 schrieb Soeren Sonnenburg:
> Dear all,
> 
> I wonder whether anyone else tried to get appletouch usb autosuspend to
> work. I've seen Oliver's patch but as it kept oopsing on me and I

You might post the oops. I haven't seen it.

> couldn't parse the usb_mark_last_busy logic I came up with the attached
> patch against (current git; at least didn't oops for me over the last
> several days and suspend/resume cycles).
> 
> However things I don't understand, 
> 
> a) is autosuspend on the appletouch driver used at all (how can I find
> out)

Compile your kernel with CONFIG_USB_DEBUG and autosuspend will be logged.
You need to activate autosuspend via sysfs.

> b) do I need dev->intf->needs_remote_wakeup = 1; ?

Yes.

> c) is line 33 in the patch safe to do ?

Why do you want to add it?

> And while we are at it I am still seeing these X falls back to hid mouse
> mode, only switching to console and back resolves this (looks like this
> only worked in previous kernels as resume from s2ram took a lot longer
> due to the IDE driver doing a couple of resets) - is there anything one
> could do about it?

Post a log.

	Regards
		Oliver

