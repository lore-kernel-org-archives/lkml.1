Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbYIALbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbYIALbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYIALa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:30:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:52323 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751056AbYIALa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:30:57 -0400
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="iso-8859-1"
Date: Mon, 01 Sep 2008 13:30:55 +0200
From: qxc@gmx.de
In-Reply-To: <20080901112816.GA27059@citd.de>
Message-ID: <20080901113055.214400@gmx.net>
MIME-Version: 1.0
References: <S1753064AbYIAJYb/20080901092431Z+302@vger.kernel.org>
 <20080901093201.105550@gmx.net> <20080901112816.GA27059@citd.de>
Subject: Re: udev and inotify
To: Matthias Schniedermeyer <ms@citd.de>
X-Authenticated: #8043265
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+M6gYvWnSMQmHlnDN0l9WB8H48xhQ03WgVCtydBi
 ypiIu0jFdn1No/14QuWUcStfmAVx2G5N7onA== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: AKfSe40deWUkXXPdE29ngmsjL0tsZk09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, thx!

-------- Original-Nachricht --------
> Datum: Mon, 1 Sep 2008 13:28:16 +0200
> Von: Matthias Schniedermeyer <ms@citd.de>
> An: qxc@gmx.de
> CC: linux-kernel@vger.kernel.org
> Betreff: Re: udev and inotify

> On 01.09.2008 11:32, qxc@gmx.de wrote:
> > Hi,
> > 
> > after I have tried it in different webboards and also in different
> mailing lists from vger.kernel.org without success I afraid I have to ask my
> question here (guessing that it is definitely the wrong mailing list):
> > 
> > I have compiled a special kernel without inotify and dnotify because the
> target system is very static and doesn't needs them (but kernel size is
> important on that system).
> > 
> > Unfortunately now I get an error message from udev that inotify is
> missing and therefore udev can't check if its cofiguration files change (what
> never will happen on that system).
> > 
> > So my question is: how do I get rid of that error message? Can I set a
> udev option somewhere that turns it off? It is verty irritating for users
> because it displays an error that is no error...
> 
> After locking into the source.
> udevd.c, main-function.
> Just look for the "inotify_init". It's the if/else if/else after that
> 
> The error-message doesn't depend on any further conditions.
> If you want to get rid of it, you have to patch it out, getting rid of 
> the else if and else should to the trick.
> 
> 
> 
> 
> 
> Bis denn
> 
> -- 
> Real Programmers consider "what you see is what you get" to be just as 
> bad a concept in Text Editors as it is in women. No, the Real Programmer
> wants a "you asked for it, you got it" text editor -- complicated, 
> cryptic, powerful, unforgiving, dangerous.

-- 
GMX Kostenlose Spiele: Einfach online spielen und Spaﬂ haben mit Pastry Passion!
http://games.entertainment.gmx.net/de/entertainment/games/free/puzzle/6169196
