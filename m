Return-Path: <linux-kernel-owner+w=401wt.eu-S1753676AbXFDJRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbXFDJRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 05:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbXFDJRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 05:17:24 -0400
Received: from lazybastard.de ([212.112.238.170]:56804 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbXFDJRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 05:17:23 -0400
Date: Mon, 4 Jun 2007 11:12:45 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Sam Ravnborg <sam@ravnborg.org>, John Stoffel <john@stoffel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       David Weinehall <tao@acc.umu.se>, Willy Tarreau <w@1wt.eu>,
       Kyle Moffett <mrmacman_g4@mac.com>, Dongjun Shin <djshin90@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, Bill Davidsen <davidsen@tmr.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Albert Cahalan <acahalan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roland Dreier <rdreier@cisco.com>,
       Ondrej Zajicek <santiago@crfreenet.org>,
       Ulisses Furquim <ulissesf@gmail.com>
Subject: Re: [Patch 04/18] include/linux/logfs.h
Message-ID: <20070604091245.GF14823@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org> <20070603184205.GE8952@lazybastard.org> <200706032342.27252.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706032342.27252.arnd@arndb.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 June 2007 23:42:25 +0200, Arnd Bergmann wrote:
> On Sunday 03 June 2007, Jörn Engel wrote:
> > +struct logfs_je_spillout {
> > +       __be64  so_segment[0];
> > +}__packed;
> 
> All the on-disk data structures you define in this file have naturally
> aligned members, so the __packed attribute is not needed.

Amen.  It is purely paranoia and I don't even know who is out to get me.

> However, I think it causes gcc to generate larger and slower code
> on some architectures, because now it has to assume that the data
> structure itself has no more than byte alignment.
> 
> I'd simply remove all instances of __packed therefore. In order
> to verify that you got it right in all cases, build with
> '-Wpadded -Wpacked'.

Fine with me.  Will do.

Jörn

-- 
Ninety percent of everything is crap.
-- Sturgeon's Law
