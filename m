Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbYELSWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbYELSWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 14:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbYELSWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 14:22:14 -0400
Received: from mail.aknet.ru ([78.158.192.26]:60036 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018AbYELSWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 14:22:13 -0400
Message-ID: <48288ACC.1020909@aknet.ru>
Date: Mon, 12 May 2008 22:22:04 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Roberto Oppedisano <roberto.oppedisano@infracom.it>
CC: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.26-rc1 regression: e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e
 breaks artsd
References: <482737BE.20502@infracom.it> <4827415A.7060101@aknet.ru> <482756F0.8020609@infracom.it> <48275D8D.10500@aknet.ru> <4827F0A1.9090600@infracom.it>
In-Reply-To: <4827F0A1.9090600@infracom.it>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Roberto Oppedisano wrote:
> With the supplied conf (and without the module option) artsd does not crash
> anymore (no sound from pc speaker but that's not an issue, my alsa-lib is
> still 1.0.16).
That's rather bad. :( With the proper
config and alsa-lib 1.0.16 it was supposed
to work...
Do the speaker beeps work?
Like those made by
---
echo -e "\a"
---
command.
Have you made sure that everything
is unmuted in alsamixer and the volume
is at maximum?
If everything fails, could you please
try the "nforce_wa=1" option to snd-pcsp?
Your chipset doesn't seem to be nforce,
but who knows, maybe the nforce workaround
will help here too...

> I can confirm that this solved any issue I had with sound,
> which is now working properly.
Thanks for the info.
