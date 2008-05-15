Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbYEORYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbYEORYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbYEORYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:24:13 -0400
Received: from mail.aknet.ru ([78.158.192.26]:60034 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbYEORYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:24:12 -0400
Message-ID: <482C71B3.8090200@aknet.ru>
Date: Thu, 15 May 2008 21:24:03 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>
CC: Takashi Iwai <tiwai@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roberto Oppedisano <roberto.oppedisano@infracom.it>
Subject: Re: [Bug #10679] 2.6.26-rc1 regression:	e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e
 breaks artsd
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A._sF.Ov1JIB@chimera> <s5hskwmeb1h.wl%tiwai@suse.de> <20080514212011.GH7054@mit.edu> <s5hhcd0azv1.wl%tiwai@suse.de> <20080515130654.GC18825@mit.edu>
In-Reply-To: <20080515130654.GC18825@mit.edu>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Theodore Tso wrote:
>> Sounds reasonable.  To where should it be added, BTW?
>> Little people seem to care about Kconfig help texts, and an extra
>> comment block (with depends on SND_PCSP) could be annoying...
> That's a good question.  A note that including including this module
> could potentially cause sound cards to be renumbered might be
> reasonable,
I guess so, and in the description
string we can probably add something
to the effect of "READ HELP!".

> enabling it as a module.  BTW, what *is* the utility of this card, and
Any utility will do.

> how do you use it?  I haven't been able to figure out how to use it do
> anything entertaining at all.  Any attempts to use it on my system
> just lead to various confusing error messages.
That's because it is a bit broken
in alsa-lib right now, more details
and the fix here:
http://lkml.org/lkml/2008/5/11/172

> Also, BTW, it might be nice to remove the following hunk of text from
> drivers/sound/Kconfig:
Yeah - that old driver never worked
with alsa anyway, so that removal is
an overdue. :)

> So I'm still rather puzzled how to make the snd-pcsp actually do
> anything useful,
It will be handled properly by default
with the next alsa-lib release. But the
trivial fix on the above URL should work
too.
