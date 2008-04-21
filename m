Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbYDURz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbYDURz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 13:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbYDURzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 13:55:48 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:61070 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbYDURzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 13:55:48 -0400
X-Greylist: delayed 657 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Apr 2008 13:55:47 EDT
Message-ID: <480CD50F.20706@aknet.ru>
Date: Mon, 21 Apr 2008 21:55:27 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-mm1 (snd-pcsp doesn't like DEBUG_PAGEALLOC)
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>	<20080419021343.GA3503@nineveh.local>	<20080418200237.b5a9e805.akpm@linux-foundation.org>	<20080419041429.GA8508@anvil.corenet.prv>	<20080418212934.bbe84ee2.akpm@linux-foundation.org> <s5h8wz7cng7.wl%tiwai@suse.de>
In-Reply-To: <s5h8wz7cng7.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Takashi Iwai wrote:
>> CONFIG_DEBUG_PAGEALLOC is a very heavy consumer of CPU cycles.  I'm not
>> surprised that it would whack what I presume to be a very latency-sensitive
>> driver.
> We can add simply a dependncy to Kconfig if this really matters.
I think this is a bit too heavy-handed.
That thing adds a lot of noise to the sound,
but it doesn't really prevent the driver from
working properly. And perhaps there are
other options with the same effect?
Also, that would motivate people to
optimize DEBUG_PAGEALLOC, while otherwise
they wouldn't know. :)

What is the problem with the warning
exactly? If it makes problems, we can
just remove it and update the help text
instead, for example.
