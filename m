Return-Path: <linux-kernel-owner+w=401wt.eu-S1762235AbXFJTWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762235AbXFJTWV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 15:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbXFJTWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 15:22:12 -0400
Received: from 1wt.eu ([62.212.114.60]:2968 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437AbXFJTWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 15:22:11 -0400
Date: Sun, 10 Jun 2007 21:20:16 +0200
From: Willy Tarreau <w@1wt.eu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       akpm@osdl.org, Sam Ravnborg <sam@ravnborg.org>,
       John Stoffel <john@stoffel.org>, David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       David Weinehall <tao@acc.umu.se>, Kyle Moffett <mrmacman_g4@mac.com>,
       Dongjun Shin <djshin90@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Bill Davidsen <davidsen@tmr.com>, Thomas Gleixner <tglx@linutronix.de>,
       Albert Cahalan <acahalan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roland Dreier <rdreier@cisco.com>,
       Ondrej Zajicek <santiago@crfreenet.org>,
       Ulisses Furquim <ulissesf@gmail.com>
Subject: Re: [Patch 15/18] fs/logfs/super.c
Message-ID: <20070610192016.GB5755@1wt.eu>
References: <20070603183845.GA8952@lazybastard.org> <200706101827.50948.arnd@arndb.de> <20070610173828.GA32619@lazybastard.org> <200706102033.11211.arnd@arndb.de> <20070610191015.GC32619@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070610191015.GC32619@lazybastard.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2007 at 09:10:15PM +0200, Jörn Engel wrote:
 
> I don't think logfs on block devices makes too much sense yet, so my
> personal priority for this is low.  Still, an obvious improvement.

I see it as a good candidate to replace JFFS2 on CompactFlash. That
one is becoming painfully slow with nowadays' smallest devices (around
64..128 MB). But since it considerably reduces the number of writes,
and it can transparently compress, it's still worth using it in some
environments.

Regards,
Willy

