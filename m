Return-Path: <linux-kernel-owner+w=401wt.eu-S936550AbXGQVN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936550AbXGQVN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbXGQVNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:13:43 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:47108
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406AbXGQVNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:13:42 -0400
Date: Tue, 17 Jul 2007 14:06:28 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
In-Reply-To: <87bqeag369.fsf@jbms.ath.cx>
Message-ID: <Pine.LNX.4.64.0707171404330.2467@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707171416120.3728-100000@iolanthe.rowland.org>
 <200707172217.01890.rjw@sisk.pl> <87odiag45q.fsf@jbms.ath.cx>
 <Pine.LNX.4.64.0707171335180.2467@asgard.lang.hm> <87bqeag369.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Jeremy Maitin-Shepard wrote:

> david@lang.hm writes:
>
> [snip]
>
>>>> * figure out which devices can wake up
>>>> * put devices into low power states (wake-up devices are placed in the Dx
>>>> states compatible with the wake capability, the others are powered off)
>
>> this can't be done by the image-saving kernel if that kernel doesn't know about
>> the device.
>
> The image-saving kernel can be made to know about all of the "wake up"
> devices; all other devices should have already been powered off by the
> "hibernated" kernel.

not nessasarily.

for example, you don't want the "hibernated" kernel to spin down your 
disks in the general case, but your image-writing kernel may not have 
drivers in it to talk to some of the disks. when things are powered 
off this just isn't an issue, but if you use S4 mode instead it is.

David Lang
