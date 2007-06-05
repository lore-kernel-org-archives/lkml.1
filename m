Return-Path: <linux-kernel-owner+w=401wt.eu-S932604AbXFEOqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604AbXFEOqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932511AbXFEOpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:45:50 -0400
Received: from lucidpixels.com ([75.144.35.66]:57991 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932371AbXFEOps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:45:48 -0400
Date: Tue, 5 Jun 2007 10:45:47 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net,
       "art@usfltd.com" <art@usfltd.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Oliver Neukum <oneukum@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Jiri Kosina <jikos@jikos.cz>, Andi Kleen <ak@suse.de>,
       discuss@x86-64.org, Ioan Ionita <opslynx@gmail.com>
Subject: Re: [5/5] 2.6.22-rc4: known regressions
In-Reply-To: <466576B9.2080203@googlemail.com>
Message-ID: <Pine.LNX.4.64.0706051044550.4372@p34.internal.lan>
References: <46657407.1000108@googlemail.com> <466576B9.2080203@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The 2.6.22-rc3 USB issue was because I did not have the deprecated USB 
option enabled.  Once I enabled it, the problem went away.  That can be 
bug can be considered resolved.

Justin.

On Tue, 5 Jun 2007, Michal Piotrowski wrote:

> Hi all,
>
> Here is a list of some known regressions in 2.6.22-rc4.
>
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions
>
>
>
> USB
>
> Subject    : Unable to get HID descriptor (error sending control message: 
> Operation not permitted)
> References : http://lkml.org/lkml/2007/6/2/153
> Submitter  : Justin Piszcz <jpiszcz@lucidpixels.com>
> Caused-By  : Kay Sievers <kay.sievers@vrfy.org>
>            commit 9f8b17e643fe6aa505629658445849397bda4e4f
> Handled-By : Oliver Neukum <oneukum@suse.de>
>            Jiri Kosina <jikos@jikos.cz>
> Status     : Unknown
>
> Subject    : usb hotplug/udev cannot correctly register usb/scanners
> References : http://lkml.org/lkml/2007/5/15/205
> Submitter  : art@usfltd.com <art@usfltd.com>
> Status     : Unknown
>
>
>
> x86-64
>
> Subject    : x86-64 2.6.22-rc2 random segfaults
> References : http://lkml.org/lkml/2007/5/24/275
> Submitter  : Ioan Ionita <opslynx@gmail.com>
> Status     : Unknown
>
>
>
> Regards,
> Michal
>
> --
> "Najbardziej brakowa?o mi twojego milczenia."
> -- Andrzej Sapkowski "Co? wi?cej"
>
