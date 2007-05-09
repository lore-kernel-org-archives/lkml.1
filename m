Return-Path: <linux-kernel-owner+w=401wt.eu-S1757670AbXEIPNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670AbXEIPNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 11:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbXEIPNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 11:13:30 -0400
Received: from tim.rpsys.net ([194.106.48.114]:59128 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060AbXEIPNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 11:13:30 -0400
Subject: Re: [PATCH 1/2] leds:arch/sh/boards/landisk LEDs supports
From: Richard Purdie <rpurdie@rpsys.net>
To: kogiidena@eggplant.ddo.jp
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org
In-Reply-To: <2490.192.168.1.10.1178720780.squirrel@eggplant.ddo.jp>
References: <1743.192.168.1.10.1178627210.squirrel@eggplant.ddo.jp>
	 <1178628889.6061.33.camel@localhost.localdomain>
	 <2490.192.168.1.10.1178720780.squirrel@eggplant.ddo.jp>
Content-Type: text/plain
Date: Wed, 09 May 2007 16:13:14 +0100
Message-Id: <1178723594.6291.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 23:26 +0900, kogiidena wrote:
> Hi Richard-san
> 
> The following three points were corrected.
> 
> 1.
> > You can't do this since the trigger will appear for all LEDs and it only
> > applies to a single LED. There has been previous discussion of LED
> > specific triggers and we'll need that support before you can make
> > something like this work. Nobody has sent me a patch for that yet and I
> > haven't had time to write one...
> The trigger name past "disk" was changed to the name "hard".
> This is to mean the hardware of LANDISK controls LED.
> The problem of "LED specific triggers" is solved.

No, its not solved.

Imagine I connect some device with its own LEDs and LED drivers. I'll
use "corgi:amber" as an example.

I run:

'cat /sys/class/leds/corgi:amber/triggers'

I see "hard" listed.

'echo "hard" > /sys/class/leds/corgi:amber/triggers'

doesn't work though...

If its not going to work, it shouldn't be listed.

Regards,

Richard


