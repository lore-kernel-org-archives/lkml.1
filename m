Return-Path: <linux-kernel-owner+w=401wt.eu-S1764300AbYEOT4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764300AbYEOT4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762137AbYEOTxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:53:49 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:48127 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762604AbYEOTxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:53:47 -0400
Date: Thu, 15 May 2008 15:53:31 -0400
From: Theodore Tso <tytso@mit.edu>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Takashi Iwai <tiwai@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roberto Oppedisano <roberto.oppedisano@infracom.it>
Subject: Re: [patch] snd-pcsp: adjust help texts to frighten users
Message-ID: <20080515195331.GM18825@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Stas Sergeev <stsp@aknet.ru>, Takashi Iwai <tiwai@suse.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Roberto Oppedisano <roberto.oppedisano@infracom.it>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A._sF.Ov1JIB@chimera> <s5hskwmeb1h.wl%tiwai@suse.de> <20080514212011.GH7054@mit.edu> <s5hhcd0azv1.wl%tiwai@suse.de> <20080515130654.GC18825@mit.edu> <482C71B3.8090200@aknet.ru> <20080515182643.GL18825@mit.edu> <482C8A43.1020208@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482C8A43.1020208@aknet.ru>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 11:08:51PM +0400, Stas Sergeev wrote:
> By description I did actually mean a
> menu string, not a help text.
> In any case, here's what I mean, in
> an attached patch.

Yep, it looks good to me.

> PS: please let us know whether the new
> PC-Speaker.conf allowed you to get any
> sound from it.

I tried replacing it, but I'm still getting silence when I use "aplay
-D plughw:0,0 /usr/share/sounds/login.wav".  If I use "aplay -D
hw:0,0", I still get the "aplay: set_params:900: Sample format non
available" error message.  This is with Ubuntu Gutsy; for a variety of
reasons, I haven't yet updated my primary laptop to Hardy yet.  I can
try booting a bleeding edge kernel on my Hardy machine and see whether
it works any better there.

					- Ted
