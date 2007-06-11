Return-Path: <linux-kernel-owner+w=401wt.eu-S1756469AbXFKXdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbXFKXdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 19:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbXFKXdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 19:33:04 -0400
Received: from lazybastard.de ([212.112.238.170]:42853 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbXFKXdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 19:33:02 -0400
Date: Tue, 12 Jun 2007 01:28:03 +0200
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
Subject: Re: [Patch 10/18] fs/logfs/inode.c
Message-ID: <20070611232803.GA5377@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org> <20070603184636.GK8952@lazybastard.org> <200706101924.29927.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706101924.29927.arnd@arndb.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 June 2007 19:24:28 +0200, Arnd Bergmann wrote:
> 
> I think this is missing code that sets the initial i_uid/i_gid,
> but there may be more missing. Changing the uid value works,
> but creating files as non-root user doesn't.

Fixed in patch 557, see
http://logfs.org/logfs/patches

The initial storm of review comments has calmed down.  I get the
impression that people either lose interest or run out of simple things
to point out.  Maybe I should wait a bit before resending?

Jörn

-- 
The competent programmer is fully aware of the strictly limited size of
his own skull; therefore he approaches the programming task in full
humility, and among other things he avoids clever tricks like the plague.
-- Edsger W. Dijkstra
