Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304Ab0BYPSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:18:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759069Ab0BYPSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:18:11 -0500
Date: Thu, 25 Feb 2010 16:18:08 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>
Subject: Re: [PATCH 1/3] picolcd: driver for PicoLCD HID device
In-Reply-To: <20100225123214.0523a310@neptune.home>
Message-ID: <alpine.LNX.2.00.1002251615570.30967@pobox.suse.cz>
References: <20100221002001.0a7e05a7@neptune.home> <20100224170049.0d04af3c@neptune.home> <alpine.LNX.2.00.1002251201430.30967@pobox.suse.cz> <20100225123214.0523a310@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Feb 2010, Bruno Prémont wrote:

> For the two sysfs attributes I currently use, the 'reset' one shall 
> probably be moved to debugfs (I would like to place it under 
> /sys/kernel/debug/hid/$device/ next to rdesc and event).

Yes, that would make sense.

( ... which reminds me to finally to the Documentation/ABI part in sync 
with respect to current HID code again ... )

> By the way, I'm wondering why event does not list any of the reports 
> coming from my device though as I understand the code it should be doing 
> that before my raw_event function gets called...

Sorry, what 'event' do you mean in 'event does not list any of the 
reports'?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
