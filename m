Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbYEOUPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbYEOUPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764514AbYEOUOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:14:35 -0400
Received: from mail.aknet.ru ([78.158.192.26]:51437 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764431AbYEOUOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:14:34 -0400
Message-ID: <482C99A4.8030201@aknet.ru>
Date: Fri, 16 May 2008 00:14:28 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>
CC: Takashi Iwai <tiwai@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roberto Oppedisano <roberto.oppedisano@infracom.it>
Subject: Re: [patch] snd-pcsp: adjust help texts to frighten users
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A._sF.Ov1JIB@chimera> <s5hskwmeb1h.wl%tiwai@suse.de> <20080514212011.GH7054@mit.edu> <s5hhcd0azv1.wl%tiwai@suse.de> <20080515130654.GC18825@mit.edu> <482C71B3.8090200@aknet.ru> <20080515182643.GL18825@mit.edu> <482C8A43.1020208@aknet.ru> <20080515195331.GM18825@mit.edu>
In-Reply-To: <20080515195331.GM18825@mit.edu>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Theodore Tso wrote:
> I tried replacing it, but I'm still getting silence when I use "aplay
> -D plughw:0,0 /usr/share/sounds/login.wav".  If I use "aplay -D
> hw:0,0", I still get the "aplay: set_params:900: Sample format non
> available" error message.
You don't need to specify anything
with the fixed conf. You probably
even _should_ not. Could you please
just try "aplay /usr/share/sounds/login.wav"
or mpg123 or anything else the most
usual way you do?
Oh, and it would be best to remove
for the moment the custom /etc/asound.conf
if any.

> This is with Ubuntu Gutsy; for a variety of
> reasons, I haven't yet updated my primary laptop to Hardy yet.  I can
> try booting a bleeding edge kernel on my Hardy machine and see whether
> it works any better there.
Well, yeah, it would be nice to have
alsa-lib 1.0.16, which one is on Gutsy?
The older ones may not support that
driver even with the good config.

PS: your messages are a bit strange.
When I press "Reply to All" in a
thunderbird mailer, it sets all the
e-mail addresses as "To:". And it
includes my own address. And it includes
your address twice. This is weird. I
am fixing that by hands.
With all other messages, by pressing
"reply to all", it composes the message
with all addresses set to "Cc:", and only
one is set to "To:", with my own address
not included at all
