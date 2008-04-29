Return-Path: <linux-kernel-owner+w=401wt.eu-S1757762AbYD2T26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762AbYD2T26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbYD2T2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:28:49 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:51188 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057AbYD2T2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:28:49 -0400
Message-ID: <481776EA.5010200@aknet.ru>
Date: Tue, 29 Apr 2008 23:28:42 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Greg KH <gregkh@suse.de>, Linux kernel <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: patch	driver-core-warn-about-duplicate-driver-names-on-the-same-bus.patch
 added to gregkh-2.6 tree
References: <12094266793898@kroah.org>	<4816A888.9000802@aknet.ru>	<20080429045849.GA6348@suse.de> <s5habjdvt6z.wl%tiwai@suse.de>
In-Reply-To: <s5habjdvt6z.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Takashi Iwai wrote:
> Though, I think the snd-pcsp driver could be better built on the top
> of input pcspkr driver, or coexist with it.  Then we'll have no more
> conflict about platform name space.
I was trying this in the past.
This never worked out very well.
I disliked the dependancies.
Either snd-pcsp was loading pcspkr,
or there had to be the global variable
to prevent the concurrent access, and
that hurts modularity.

> When you compare input pcspkr.c and sound pcsp_input.c, you can find
> that most of codes are identical.
Yep, its a copy/paste mainly.
I wanted a complete replacement.
Back then, I've been told that multiple
drivers controlling the same device is
never a good idea. But I won't be surprised
if that have changed since. :)

> What we'd need is a hook on
> pcspkr.c that adds a dynamic check whether snd-pcsp (or any ohter)
> is running.
How?
And also, with snd-pcsp you have a
mixer control to disable the beeps,
which I find sometimes even more
usefull than the pcm sound itself. :)
