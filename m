Return-Path: <linux-kernel-owner+w=401wt.eu-S1761043AbYEQWGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761043AbYEQWGA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 18:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760016AbYEQWFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 18:05:52 -0400
Received: from mail.aknet.ru ([78.158.192.26]:59808 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbYEQWFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 18:05:51 -0400
Message-ID: <482F56A5.7000008@aknet.ru>
Date: Sun, 18 May 2008 02:05:25 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Jones <davej@codemonkey.org.uk>
CC: Takashi Iwai <tiwai@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Subject: Re: [Bug #10679] 2.6.26-rc1 regression:	e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e
 breaks artsd
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A._sF.Ov1JIB@chimera> <s5hskwmeb1h.wl%tiwai@suse.de> <20080514212011.GH7054@mit.edu> <s5hhcd0azv1.wl%tiwai@suse.de> <20080515130654.GC18825@mit.edu> <s5h8wybr0c2.wl%tiwai@suse.de> <20080517204725.GA11460@codemonkey.org.uk> <482F47DC.60505@aknet.ru> <20080517213231.GA31440@codemonkey.org.uk>
In-Reply-To: <20080517213231.GA31440@codemonkey.org.uk>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Dave Jones wrote:
> Unless someone has 10 sound cards :-)  (Sounds bizarre, but I never tire
> of seeing some of the creative situations our users get themselves into).
Yes, the hardcoded values sucks...

> Something like this is probably the only real supportable way to do it though.
> It would be great if alsa took something like -1 to mean 'never make this default'.
-1 seems to be already reserved for
"use first free slot", but maybe it
would be nice to reserve some value
for the "movable" index. For example,
the index -2 can mean "use the first
free slot, but move to the next one
when some other driver is registering
with -1 or explicitly to that slot".
Of course I have no idea whether this
is possible and acceptable, but maybe
the alsa guys can tell.

> But until that lands in a module-init-tools update, we're kind of stuck.
Well, they won't take 10 or any other
value I guess...
