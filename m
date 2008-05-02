Return-Path: <linux-kernel-owner+w=401wt.eu-S935361AbYEBQWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935361AbYEBQWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 12:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759310AbYEBQWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 12:22:39 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:54170 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757788AbYEBQWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 12:22:38 -0400
Message-ID: <481B3FBF.9070004@aknet.ru>
Date: Fri, 02 May 2008 20:22:23 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Linux kernel <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: patch	driver-core-warn-about-duplicate-driver-names-on-the-same-bus.patch
 added to gregkh-2.6 tree
References: <12094266793898@kroah.org>	<4816A888.9000802@aknet.ru>	<20080429045849.GA6348@suse.de>	<s5habjdvt6z.wl%tiwai@suse.de>	<481776EA.5010200@aknet.ru>	<s5h7ief7sw3.wl%tiwai@suse.de>	<4818B057.4080803@aknet.ru>	<s5hk5ic3ilu.wl%tiwai@suse.de>	<481B355B.9040200@aknet.ru> <s5h63tw3dd3.wl%tiwai@suse.de>
In-Reply-To: <s5h63tw3dd3.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Takashi Iwai wrote:
>> Another point is PM callbacks. Somehow
>> snd-pcsp will have to register them with
>> pcspkr.
> Hmm, isn't platform PM hook enough?
> pcspkr.c just sends an event at suspend or shutdown to the event
> handler.  So, if the event was shut up at the beginning in the
> handler, nothing would be needed.
I don't think I understand what you mean...
Currently, pcspkr.c just stops the timer
counter to shut up the beep.
snd-pcsp needs more. snd_pcm_suspend_all()
for instance. Since it doesn't register
itself as a platform driver any more, he
have to register itself into pcspkr.c.
Or?
I mean, sending a "shut up" event to the
pcspkr's handler is not what snd-pcsp
needs to do.
