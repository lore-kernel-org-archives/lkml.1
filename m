Return-Path: <linux-kernel-owner+w=401wt.eu-S1753585AbXFOLTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbXFOLTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 07:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbXFOLSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 07:18:55 -0400
Received: from [212.112.238.170] ([212.112.238.170]:45124 "EHLO
	longford.lazybastard.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750779AbXFOLSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 07:18:54 -0400
Date: Fri, 15 Jun 2007 13:14:04 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Sam Ravnborg <sam@ravnborg.org>, John Stoffel <john@stoffel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       David Weinehall <tao@acc.umu.se>, Arnd Bergmann <arnd@arndb.de>,
       Willy Tarreau <w@1wt.eu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Dongjun Shin <djshin90@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Bill Davidsen <davidsen@tmr.com>, Thomas Gleixner <tglx@linutronix.de>,
       Albert Cahalan <acahalan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roland Dreier <rdreier@cisco.com>,
       Ondrej Zajicek <santiago@crfreenet.org>,
       Ulisses Furquim <ulissesf@gmail.com>
Subject: Re: [Patch 09/18] fs/logfs/gc.c
Message-ID: <20070615111404.GB6791@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org> <20070603184604.GJ8952@lazybastard.org> <20070615090357.GC20361@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070615090357.GC20361@2ka.mipt.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 June 2007 13:03:57 +0400, Evgeniy Polyakov wrote:
> On Sun, Jun 03, 2007 at 08:46:04PM +0200, Jörn Engel (joern@lazybastard.org) wrote:
> > --- /dev/null	2007-03-13 19:15:28.862769062 +0100
> > +++ linux-2.6.21logfs/fs/logfs/gc.c	2007-06-03 19:18:57.000000000 +0200
> 
> Number of bugs in case of error looks quite sad...

Agreed.  I've started working on error handling.  Most erase errors are
dealt with.  Write errors still need some infrastructure.

If you like I can send another round of patches for review.

Jörn

-- 
Joern's library part 12:
http://physics.nist.gov/cuu/Units/binary.html
