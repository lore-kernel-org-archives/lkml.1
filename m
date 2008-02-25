Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbYBYVdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbYBYVdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbYBYVdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:33:11 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54018 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbYBYVdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:33:09 -0500
Message-ID: <47C333F6.40501@garzik.org>
Date: Mon, 25 Feb 2008 16:32:38 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org
Subject: Re: broken suspend in .2.6.25-rc3 on T61p (was Re: new regression
 in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p)
References: <8f53421d0802251119q470a79c1p31048ef136271f84@mail.gmail.com> <20080225114611.d91791f6.akpm@linux-foundation.org> <8f53421d0802251245j5439b37die840e34bb293f995@mail.gmail.com> <200802252157.10412.rjw@sisk.pl> <20080225212615.GA2659@elf.ucw.cz>
In-Reply-To: <20080225212615.GA2659@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>> commit 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2
>> Author: Pavel Machek <pavel@ucw.cz>
>> Date:   Thu Feb 21 13:56:55 2008 +0100
>>
>>     power_state: get rid of write-only variable in SATA
> 
> This is pretty unlikely to be it. Can you double check that this patch
> really breaks something?

Quote...

	After reverting 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2
	on top of 2.6.25-rc3 the kernel again resumes from suspend to
	ram.

Seems pretty clear to me.

	Jeff


