Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbXIMNVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbXIMNVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 09:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbXIMNVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 09:21:38 -0400
Received: from rtr.ca ([76.10.145.34]:2702 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbXIMNVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 09:21:36 -0400
Message-ID: <46E9395F.2090300@rtr.ca>
Date: Thu, 13 Sep 2007 09:21:35 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Markus <lists4me@web.de>, Jeff Chua <jeff.chua.linux@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>, linux-alpha@vger.kernel.org,
       Stefan Becker <Stefan.Becker@nokia.com>, Andi Kleen <ak@suse.de>,
       Dave Jones <davej@redhat.com>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Jakub Jelinek <jakub@redhat.com>, Jeff Dike <jdike@linux.intel.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [1/4] 2.6.23-rc6: known regressions
References: <46E81AC6.3000306@googlemail.com> <46E8A572.7050209@rtr.ca> <20070913093651.GA5077@suse.de>
In-Reply-To: <20070913093651.GA5077@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Sep 12, 2007 at 10:50:26PM -0400, Mark Lord wrote:
>> Michal Piotrowski wrote:
>>> Hi all,
>>> Here is a list of some known regressions in 2.6.23-rc6.
>> ...
>>
>> Missing from the list:
>>
>> USB "autosuspend" feature (new in 2.6.23) breaks *lots* of devices.
>> Many have since been blacklisted in one-at-a-time discovery patches,
>> but that's really just the tip of the iceberg.
>>
>> This "feature" breaks a TON of user-visible things,
>> mostly USB storage devices (USB drives/pens, digicams, etc..).
>>
>> The functionality is broken for just too much stuff,
>> and needs to either be reverted or defaulted to "off" rather than "on".
> 
> Ok, after conferring with Oliver this morning, I think the best solution
> here is to both revert the usb-storage suspend patch as it has some
> basic problems that can cause data loss, _and_ add the change to the
> kernel that by default disables autosuspend on all USB devices except
> hubs.

Sounds like a sane approach.

Hopefully the kinks can be worked out in time for a reattempt in 2.6.24.
I understand how important this stuff is for battery powered devices,
but it just doesn't appear to be ready yet.

Cheers
