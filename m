Return-Path: <linux-kernel-owner+w=401wt.eu-S1759946AbYF3JmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946AbYF3JmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 05:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbYF3Jlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 05:41:50 -0400
Received: from smtp.nokia.com ([192.100.122.233]:43376 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbYF3Jlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 05:41:49 -0400
Message-ID: <4868A8B1.3090805@nokia.com>
Date: Mon, 30 Jun 2008 12:34:41 +0300
From: Stefan Becker <Stefan.Becker@nokia.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: ext David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, ext Alan Stern <stern@rowland.harvard.edu>
CC: ext Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: PATCH: 2.6.26-rc8: Fix IRQF_DISABLED for shared interrupts
References: <Pine.LNX.4.44L0.0806281241200.23326-100000@netrider.rowland.org> <200806281251.21299.david-b@pacbell.net> <4867A2DE.3070509@nokia.com> <200806292009.26975.david-b@pacbell.net>
In-Reply-To: <200806292009.26975.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jun 2008 09:34:42.0026 (UTC) FILETIME=[861F1CA0:01C8DA94]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

ext David Brownell wrote:
> 
> And it looks plausible to me.  Seems like this patch (or a variant)
> should be merged for 2.6.26-final, yes?  Disregarding IRQF_DISABLED
> has -- as you noted -- significant potential for oopsage.

It seems IRQF_SHARED | IRQF_DISABLED has already been discussed several 
times on LKML:

<http://thread.gmane.org/gmane.linux.kernel/638251>
<http://thread.gmane.org/gmane.linux.kernel/561205>

Especially this message

<http://thread.gmane.org/gmane.linux.kernel/561205/focus=561222>

makes me think that Linus will reject my proposed patch for the lockup 
problem as it implements choice (c) on his list.


Alan: should I try to implement his choice (f) insteadn, i.e. drop 
IRQF_DISABLED from USB HCD interrupts and disable interrupts in 
usb_hcd_irq() instead?

Regards,

	Stefan

---
Stefan Becker
E-Mail: Stefan.Becker@nokia.com
