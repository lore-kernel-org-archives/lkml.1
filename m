Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab0CCRED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:04:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892Ab0CCREA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:04:00 -0500
Date: Wed, 3 Mar 2010 09:03:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dima Zavin <dmitriyz@google.com>
cc: Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
In-Reply-To: <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>
References: <4B8C1867.7040201@cam.ac.uk> <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Mar 2010, Dima Zavin wrote:
> 
> I definitely see the need for what you guys are trying to accomplish.
> For example, currently, we use an input device for reporting events,
> and a separate misc device node for control
> (enable/disable/configure). It's definitely suboptimal, but there
> currently isn't anything there would let us do things cleanly.

I have to say, I personally don't see why something like an ambient light 
sensor _isn't_ just an input device. 

What's the difference between a physical "increase screen brightness" key, 
and a "ambient light sensor"? Absolutely none as far as I can tell.

And for something like an X server, it sounds a lot more natural to just 
have another input device than to have yet abother event reporting 
interface.

And quite frankly, the "explanations" I see in this thread for why it 
needs to be a subsystem of its own don't actually explain anything or make 
sense. They seem to boil down to "we just did it this way" without 
actually answering any of the issues brought up.

		Linus
