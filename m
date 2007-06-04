Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbXFDNyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbXFDNyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 09:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbXFDNyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 09:54:09 -0400
Received: from canuck.infradead.org ([209.217.80.40]:46432 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbXFDNyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 09:54:07 -0400
Subject: Re: [Patch 06/18] fs/logfs/compr.c
From: David Woodhouse <dwmw2@infradead.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       akpm@osdl.org, Sam Ravnborg <sam@ravnborg.org>,
       John Stoffel <john@stoffel.org>, Jamie Lokier <jamie@shareable.org>,
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
In-Reply-To: <20070604085447.GA14823@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org>
	 <20070603184355.GG8952@lazybastard.org> <200706032358.44870.arnd@arndb.de>
	 <20070604085447.GA14823@lazybastard.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 04 Jun 2007 14:53:46 +0100
Message-Id: <1180965226.25232.361.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 10:54 +0200, Jörn Engel wrote:
> There is no particular reason.  '3' should be a reasonable value for
> most people.  If actual users want to change this value, I can make it
> a mount option as well.  Right now I'm just lazy and doubt the merits.

I think you probably made the right choice. If you're compressing small
chunks at a time, increasing the amount of history which the compressor
will keep really doesn't buy you much.

-- 
dwmw2

