Return-Path: <linux-kernel-owner+w=401wt.eu-S971048AbXILRZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971048AbXILRZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970360AbXILRZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:25:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39320 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970143AbXILRZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:25:23 -0400
Date: Wed, 12 Sep 2007 10:19:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Arkadiusz Miskiewicz <arekm@maven.pl>,
       Thomas Voegtle <tv@lio96.de>, Soeren Sonnenburg <kernel@nn7.de>,
       Christian Leber <christian@leber.de>, Alan Cox <alan@redhat.com>,
       David Miller <davem@davemloft.net>, Andy Whitcroft <apw@shadowen.org>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, Tino Keitel <tino.keitel@gmx.de>
Subject: Re: [4/4] 2.6.23-rc6: known regressions
In-Reply-To: <46E81ADC.4030902@googlemail.com>
Message-ID: <alpine.LFD.0.999.0709121018560.16478@woody.linux-foundation.org>
References: <46E8187E.9000006@googlemail.com>
 <46E81ADC.4030902@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 12 Sep 2007, Michal Piotrowski wrote:
> 
> Subject         : 2.6.23-rc6-git1 -- termios *_1 compile failures on powerpc
> References      : http://lkml.org/lkml/2007/9/12/101
> Last known good : ?
> Submitter       : Andy Whitcroft <apw@shadowen.org>
> Caused-By       : David Miller <davem@davemloft.net>
>                   commit f629307c857c030d5a3dd777fee37c8bb395e171
> Handled-By      : ?
> Status          : unknown

Should be fixed by b0052fcaefb829a29fdc6567274daf0b75329fc3 ("Define 
termios_1 functions for powerpc, s390, avr32 and frv").

		Linus
