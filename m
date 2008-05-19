Return-Path: <linux-kernel-owner+w=401wt.eu-S1762016AbYESSKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762016AbYESSKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 14:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbYESSKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 14:10:31 -0400
Received: from mail.aknet.ru ([78.158.192.26]:54837 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbYESSKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 14:10:30 -0400
Message-ID: <4831C283.3050306@aknet.ru>
Date: Mon, 19 May 2008 22:10:11 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Non-working snd-pcsp
References: <482737BE.20502@infracom.it> <4827415A.7060101@aknet.ru> <482756F0.8020609@infracom.it> <48275D8D.10500@aknet.ru> <4827F0A1.9090600@infracom.it> <48288ACC.1020909@aknet.ru> <48299F08.2060702@infracom.it> <4829B6A1.90707@infracom.it> <s5h7idycfmf.wl%tiwai@suse.de> <482A7A17.8070706@infracom.it> <s5hwslxb3t8.wl%tiwai@suse.de> <482C9A3E.3000009@infracom.it> <482C9F3E.4050104@aknet.ru> <alpine.LNX.1.10.0805161514190.15590@fbirervta.pbzchgretzou.qr> <s5hmymqe5a1.wl%tiwai@suse.de> <alpine.LNX.1.10.0805161715470.15590@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0805161715470.15590@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Jan Engelhardt wrote:
> Previously, with Stas's standalone patch, one was able to switch
> between (a) no speaker (b) beep/pcspkr (c) beep/pcspkr and
> PCM/snd-pcsp, all by means of modprobe/rmmod.
But now you can get any such combination
by the use of alsamixer only.

> Except if snd-pcsp itself contains beep code, and that would
> be sort of redundant when it is already in pcspkr.
It is redundant only if you _intend_
to use both drivers. But its usually
a bad idea to have multiple drivers
serving the single device simultaneously.
The other way of thinking about it,
is that you simply use a new driver
instead of an old one. The new one
does everything the old one did and
more. Since they can't be built together,
the redundancy is then only in a source
code.
I am not saying it is an ideal solution.
It is not, but for only a single reason -
people who need only beeps, may not
want to have the entire sound subsystem
loaded. So they want pcspkr to be at
least built. But getting these drivers
back together again, suddenly became
very problematic...
