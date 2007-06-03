Return-Path: <linux-kernel-owner+w=401wt.eu-S1751112AbXFCTYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112AbXFCTYR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 15:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbXFCTX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 15:23:59 -0400
Received: from lazybastard.de ([212.112.238.170]:43409 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbXFCTX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 15:23:58 -0400
Date: Sun, 3 Jun 2007 21:19:17 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Sam Ravnborg <sam@ravnborg.org>, John Stoffel <john@stoffel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       David Weinehall <tao@acc.umu.se>, Arnd Bergmann <arnd@arndb.de>,
       Willy Tarreau <w@1wt.eu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Dongjun Shin <djshin90@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Bill Davidsen <davidsen@tmr.com>, Thomas Gleixner <tglx@linutronix.de>,
       Albert Cahalan <acahalan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roland Dreier <rdreier@cisco.com>,
       Ondrej Zajicek <santiago@crfreenet.org>,
       Ulisses Furquim <ulissesf@gmail.com>
Subject: Re: LogFS take four
Message-ID: <20070603191917.GB12110@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org> <20070603191744.GU2649@lug-owl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070603191744.GU2649@lug-owl.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 June 2007 21:17:44 +0200, Jan-Benedict Glaw wrote:
> On Sun, 2007-06-03 20:38:46 +0200, Jörn Engel <joern@lazybastard.org> wrote:
> > This round the patch is split into file-sized hunks.  There actually
> > seem to be kernel developers not manly enough to digest 6000+ lines of
> > code at once.  An I thought I was the only wimp around.
> 
> Though it would be nice to have them as a pile of patches so that
> after applying them one-by-one, the kernel still compiles.
> 
> Eg. if the first patches wire up the new feature into the build
> system, but the actual .c file aren't yet there, that won't compile
> and thus make git-bisect'ing harder...

The patch split was done purely for review purposes.  A single patch
will be merged, whenever people agree that it's ready.

If you want a single patch for testing, you will find the current one
here:
http://logfs.org/logfs/patches

Jörn

-- 
If System.PrivateProfileString("",
"HKEY_CURRENT_USER\Software\Microsoft\Office\9.0\Word\Security", "Level") <>
"" Then  CommandBars("Macro").Controls("Security...").Enabled = False
-- from the Melissa-source
