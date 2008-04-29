Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbYD2T5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbYD2T5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYD2T4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:56:55 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:63740 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbYD2T4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:56:54 -0400
Message-ID: <48177D70.5010803@aknet.ru>
Date: Tue, 29 Apr 2008 23:56:32 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>,
       Michael Opdenacker <michael@free-electrons.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] pcspkr: fix dependancies
References: <4813476A.7000705@aknet.ru> <200804261918.14711.dtor-oss@comcast.net> <4813BD39.1080105@aknet.ru> <20080427042331.GB29127@anvil.corenet.prv> <481626B6.5040207@aknet.ru> <20080428155811.ZZRA012@mailhub.coreip.homeip.net> <20080428201225.GB18135@uranus.ravnborg.org>
In-Reply-To: <20080428201225.GB18135@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Sam Ravnborg wrote:
> If you google you will find a long thread about this patch.
Yes, indeed, thankyou.
http://kerneltrap.org/mailarchive/linux-kernel/2008/1/17/577151

> It is all about saving memory for embedded platforms.
OK. This wasn't clear from the log
message for some reason, but it is
said in the above thread.

> No need to have the driver if there is no speaker on the board.
Very probably, and for that case I
made the patch like this:
http://uwsg.ucs.indiana.edu/hypermail/linux/kernel/0804.3/1189.html

> Ask Michael (author) if you need more info.
Reading the thread, it actually seems
like Michael wanted to submit the patch
much like the aforementioned one of
mine:
http://kerneltrap.org/mailarchive/linux-kernel/2008/1/18/580583
but haven't done so in time, and as the
result, the wrong one stuck in.
But this is never too late to correct, I
hope.

So I see 2 options: either revert the
patch completely, or revert the dependancies
like Michael suggested initially (if I
understand his suggestion right).
Both patches are here, in this thread.
Thoughts?
