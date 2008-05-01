Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbYEAHId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbYEAHId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 03:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbYEAHI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 03:08:26 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:50281 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbYEAHI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 03:08:26 -0400
Message-ID: <48196C58.4030004@aknet.ru>
Date: Thu, 01 May 2008 11:08:08 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Michael Opdenacker <michael-lists@free-electrons.com>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] pcspkr: fix dependancies
References: <4813476A.7000705@aknet.ru> <200804261918.14711.dtor-oss@comcast.net> <4813BD39.1080105@aknet.ru> <20080427042331.GB29127@anvil.corenet.prv> <481626B6.5040207@aknet.ru> <20080428155811.ZZRA012@mailhub.coreip.homeip.net> <20080428201225.GB18135@uranus.ravnborg.org> <48177D70.5010803@aknet.ru> <4818205B.7050202@free-electrons.com>
In-Reply-To: <4818205B.7050202@free-electrons.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys, there really needs to be a
few more replies to make a decision.

So far only Dmitry have clearly stated
his opinion regarding both patches.
And that opinion was: no need for the
new config option, just get the 2.6.25
patch reverted.
Dmitry, after reading the older Michael's
thread, would you perhaps reconsider?

Sam and Michael said that just revering
may not be a good idea, but have not
commented on the patch that adds a new
option under "if EMBEDDED".

That puts me in a position where both
patches are effectively blocked, and
in a mean time snd-pcsp remains broken.

Guys, please, give your ACK or NACK on
the two posted patches! :)
Namely:
http://lkml.org/lkml/2008/4/26/105
http://lkml.org/lkml/2008/4/26/283
